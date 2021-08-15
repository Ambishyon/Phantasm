local Libraries = script.Parent.Parent.Libraries
local ObjectCache = require(Libraries.ObjectCache)
local BoatTween = require(Libraries.BoatTween)
local Util
local Classes = script.Parent
local Maid = require(Classes.Maid)
local Navigator = require(Classes.Navigator)
local AnimationStack = require(Classes.AnimationStack)
local Animator = require(Classes.Animator)

local caches = {}

function getSizeFromParent(udim2: UDim2, parent: GuiBase2d, absolute: boolean)
	return UDim2.fromOffset((udim2.X.Scale * parent.AbsoluteSize.X) + udim2.X.Offset + (absolute and parent.AbsolutePosition.X or 0), (udim2.Y.Scale * parent.AbsoluteSize.Y) + udim2.Y.Offset + (absolute and parent.AbsolutePosition.Y or 0))
end

local class = {}
Navigator(class)

function class.new(name: string, data: table, tree: table, parent: table|nil)
	if Util == nil then
		Util = require(Libraries.Util)
	end
	local self = {}

	if caches[data.ClassName] == nil then
		caches[data.ClassName] = ObjectCache.new(Instance.new(data.ClassName), 100, script)
	end

	self.ClassName = data.ClassName
	self.Properties = data.Properties
	self.Data = data
	self.Children = {}
	self.Tree = tree
	self.AnimationStack = AnimationStack.new(self)
	self.Parent = parent

	self.Animations = {}
	self.Sounds = {}

	self.State = "Normal"
	self.ActiveStates = {}

	self.StateAnimations = {}
	self.__Bindings = {}
	self.__OriginalProperties = {}

	self.Object = caches[self.ClassName]:GetObject()
	self.Maid = Maid.new()

	self.Object.Name = name
	self.Name = name

	if parent then
		self.Object.Parent = (type(parent.Object) == "table" and parent.Object.Object) or (parent.Object)
	end

	-- Setup initial state animation
	local initialProperties = {}
	for prop, val in pairs(data.Properties) do
		-- Only allow types that BoatTween supports
		if not Util:IsTweenable(val) then continue end
		initialProperties[prop] = val
	end

	local normalState = data.StateAnimations and data.StateAnimations.Normal or {}
	self.StateAnimations.Normal = {
		EasingStyle = normalState.EasingStyle or "Sine";
		EasingDirection = normalState.EasingDirection or "Out";
		Time = normalState.Time or nil;
		Goal = initialProperties;
	}

	self.__StateAnimations = {}

	-- Setup state animations
	if data.StateAnimations then
		for state, info in pairs(data.StateAnimations) do
			-- The info for the normal state is only used for the easing style and direction as well as time so we skip it here
			if state == "Normal" then continue end
			Util:DebugPrint(string.format("Setup state animation data '%s' for element '%s'", state, name))
			Util:DebugPrint(info)
			self.StateAnimations[state] = info
		end
	end

	-- Setup sound information
	if data.Sounds then
		for state, sound in pairs(data.Sounds) do
			self.Sounds[state] = sound
		end
	end

	-- Setup element animations
	if data.Animations then
		for index, animData in pairs(data.Animations) do
			self.Animations[index] = Animator.new(self, animData)
		end
	end

	-- Setup default state handlers
	do
		if self.Object:IsA"GuiObject" then
			self.Maid:GiveTask(self.Object.MouseEnter:Connect(function()
				self.ActiveStates.Hover = true
			end))

			self.Maid:GiveTask(self.Object.MouseLeave:Connect(function()
				self.ActiveStates.Hover = false
			end))
		end

		if self.Object:IsA"TextBox" then
			self.Maid:GiveTask(self.Object.Focused:Connect(function()
				self.ActiveStates.Focused = true
			end))

			self.Maid:GiveTask(self.Object.FocusLost:Connect(function()
				self.ActiveStates.Focused = false
			end))
		end

		if self.Object:IsA"GuiButton" then
			self.Maid:GiveTask(self.Object.MouseButton1Down:Connect(function()
				self.ActiveStates.Pressed = true
			end))

			self.Maid:GiveTask(self.Object.MouseButton1Up:Connect(function()
				self.ActiveStates.Pressed = false
			end))
		end
	end

	return setmetatable(self, class)
end

function class:Render()
	local parent do
		if self.Parent:IsA("Element") then
			parent = self.Parent.Object
		else
			parent = self.Parent
		end
	end
	-- Setup initial properties to reset once the element is destroyed
	for prop, _ in pairs(self.Properties) do
		if self.__OriginalProperties[prop] == nil then
			self.__OriginalProperties[prop] = self.Object[prop]
		end
	end

	-- Update bindings
	for prop, val in pairs(self.Properties) do
		if type(val) == "table" and val.Type == "Binding" then
			local binding = Util:GetBinding(self.Tree, val.Name)
			if binding then
				local result = binding(self, val.Settings, prop)
				if self.__Bindings[prop] ~= result then
					if typeof(result) == "UDim2" then
						result = getSizeFromParent(result, parent)
					end
					self.__Bindings[prop] = result
					self.Object[prop] = result
				end
			end
		end
	end

	-- Determine current state
	local activeStates = self.ActiveStates
	local State do
		if activeStates.Pressed then
			State = "Pressed"
		elseif activeStates.Focused then
			State = "Focused"
		elseif activeStates.Hover then
			State = "Hover"
		else
			State = "Normal"
		end
	end

	-- Play the appropriate state animation and/or sound if present
	if self.State ~= State then
		Util:DebugPrint(string.format("Element '%s' has entered state '%s' from state '%s'", self.Name, State, self.State))
		local enteringSound = self.Sounds[State]
		if enteringSound then
			local sound = Instance.new("Sound")
			for prop, val in pairs(enteringSound) do
				sound[prop] = val
			end
			sound.Ended:Connect(function()
				sound:Destroy()
			end)
			sound.Parent = workspace

			Util:DebugPrint(string.format("Playing state sound '%s' for element '%s'", State, self.Name))
			sound:Play()
		end

		local leavingStateAnimation = self.StateAnimations[self.State]
		if leavingStateAnimation then
			local enteringStateAnim = self.StateAnimations[State]

			if enteringStateAnim then
				local animToUse = enteringStateAnim

				if State == "Normal" then
					animToUse = Util:DeepCopy(self.StateAnimations.Normal)
					local newGoal = {}

					for prop, val in pairs(leavingStateAnimation.Goal) do
						newGoal[prop] = enteringStateAnim.Goal[prop]
					end

					animToUse.Goal = newGoal
				else
					for prop, val in pairs(enteringStateAnim.Goal) do
						if self.StateAnimations.Normal.Goal[prop] == nil then
							self.StateAnimations.Normal.Goal[prop] = val
						end
					end
				end

				for _, animSet in pairs(self.__StateAnimations) do
					animSet:Stop()
					animSet:Destroy()
				end

				Util:DebugPrint(string.format("Playing state animation '%s' for element '%s'", State, self.Name))
				local properties = Util:DeepCopy(rawget(self, "Properties"))
				local newStateTween = BoatTween:Create(properties, animToUse)
				self.__StateAnimations[State] = newStateTween
				-- Add the state animation to the bottom of the stack (actual animations should take precedence over state-based ones)
				self.AnimationStack:AddToStack({
					Animator = newStateTween;
					Properties = properties;
				}, 0)
			end
		end
	end

	-- Update the state
	self.State = State

	-- Update the animation stack
	self.AnimationStack:Update()

	-- Update Size
	if self.Object:IsA"GuiObject" and self.Properties.Size then
		if typeof(self.Properties.Size) == "UDim2" then
			self.Object.Size = getSizeFromParent(self.Properties.Size, parent)
		end
	end

	-- Update Position
	if self.Object:IsA"GuiObject" and self.Properties.Position then
		if typeof(self.Properties.Position) == "UDim2" then
			self.Object.Position = getSizeFromParent(self.Properties.Position, parent, self.Object.Parent == self.Tree.OverlayGUI)
		end
	end

	-- Update changed properties
	if self.__Properties == nil then
		self.__Properties = {}
	end

	if self.Name == "Slider" then
		Util:DebugPrint(self.__Properties, self.Properties)
	end
	if not Util:CompareTables(self.__Properties, self.Properties) then
		Util:DebugPrint(string.format("Element '%s' has changed.", self.Name))
		local changeList = Util:GenerateDifferences(self.__Properties, self.Properties)

		local combinedChanges = Util:CombineTables(changeList.Changes, changeList.Additions)

		for prop, val in pairs(combinedChanges) do
			Util:DebugPrint(string.format("Element '%s' property '%s' changed to:", self.Name, prop), val)
			if prop == "Size" or prop == "Position" then
				-- Skip size and position as we already handle them above
				self.__Properties[prop] = type(val) == "table" and Util:DeepCopy(val) or val
				continue
			end
			if typeof(self.Object[prop]) == "RBXScriptSignal" then
				if self.Maid[prop] then
					self.Maid[prop] = nil
				end
				if type(val) == "table" then
					-- It's a preset function, get the actual function
					local result = Util:GetFunction(self.Tree, val.Name)
					if result then
						self.Maid[prop] = self.Object[prop]:Connect(function(...)
							result.Run(self, val.Properties, ...)
						end)
					end
				elseif type(val) == "function" then
					-- If it is a function or this isn't the first iteration, we
					-- Don't apply the change as we can be 99% certain it is
					-- The same one from before.
					if type(self.__Properties[prop]) ~= "function" then
						self.Maid[prop] = self.Object[prop]:Connect(val)
					end
				else
					warn(string.format("Failed to connect event for '%s': expected a function or a reference to an engine function, got '%s' instead.", prop, typeof(val)))
				end
			else
				-- According to my knowledge, no known Roblox classes have table-based properties
				-- So we can safely skip these value types, if this changes in the future this
				-- will be fixed.
				if type(val) == "table" then continue end
				-- If it is a UDim2 value, we convert the value use offset only
				-- Due to the nature of ScrollingFrames, this is a hacky solution to work around them
				-- using CanvasSize instead of the frame's size.
				if typeof(val) == "UDim2" then
					val = getSizeFromParent(val, parent)
				end
				self.Object[prop] = val
			end
			self.__Properties[prop] = type(val) == "table" and Util:DeepCopy(val) or val
 		end
	end

	-- Render all children
	for _, child in pairs(self.Children) do
		child:Render()
	end
end

function class:PlayAnimation(name)
	local animator = self.Animations[name]

	assert(animator, string.format("An animation with the name '%s' does not exist on element '%s'", name, self.Name))
	if not animator.Playing then
		self.AnimationStack:AddToStack(animator.StackData)
	end
end

function class:StopAnimation(name)
	local animator = self.Animations[name]

	assert(animator, string.format("An animation with the name '%s' does not exist on element '%s'", name, self.Name))
	animator:Stop()
end

function class:Tween(data)
	local properties = Util:DeepCopy(self.Properties)
	local tween = BoatTween:Create(properties, data)
	-- Add the tween to the top of the stack
	self.AnimationStack:AddToStack{
		Animator = tween;
		Properties = properties;
	}

	-- Return the tween object so that the developer can cancel it if needed
	return tween
end

function class:IsA(name)
	return self.Object:IsA(name) or name == "Element"
end

function class:Destroy()
	if self.Object == nil then return end
	for _, element in pairs(self.Children) do
		element:Destroy()
	end

	self.Maid:DoCleaning()

	for prop, val in pairs(self.__OriginalProperties) do
		self.Object[prop] = val
	end

	caches[self.ClassName]:ReturnObject(self.Object)
	self.Object = nil
end

return class
