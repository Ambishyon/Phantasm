local RunService = game:GetService("RunService")

local module = {}
local Libraries = script.Libraries
local Util = require(Libraries.Util)
local Classes = script.Classes
local Element = require(Classes.Element)
local Interface = require(Classes.Interface)

local MountedInterfaces = {}

local function buildTree(data)
	local tree = {}

	local function index(object, parent)
		local results = {}
		for name, element in pairs(object) do
			local props = {}

			for prop, val in pairs(element.Properties) do
				if type(val) == "table" then
					if val.Type == "Binding" then
						local binding = data.Bindings[val.Name]
						props[prop] = binding(val.Settings)
					else
						props[prop] = val
					end
				else
					props[prop] = val
				end
			end

			local structure = {
				ClassName = element.ClassName;
				Properties = props;
				Children = index(element.Children, object.ClassName ~= nil and object or nil);
			}
			results[name] = structure
		end
	end

	index(data.Elements)

	return tree
end

function module.mountInterface(data)
	local newInterface = Interface.new(data)

	table.insert(MountedInterfaces, newInterface)

	return newInterface
end

RunService.RenderStepped:Connect(function(dt)
	for _, interface in pairs(MountedInterfaces) do
		local currentTree = interface.Tree
		local newTree = buildTree(interface.Data)

		-- Compare the current tree against the new one for any differences
		if not Util:CompareTables(currentTree, newTree) then
			-- Something in the interface's structure has changed, rebuild the changed stuff.
			local changeList = Util:GenerateDifferences(currentTree, newTree)
			Util:ApplyDifferences(interface.Tree, changeList)

			local function TraverseDifferences(what, element)
				for i, v in pairs(what.Additions) do
					-- A new element was added, create it in the element tree.
					local original = Element.new(v)
					original.Object.Parent = element.Object
					if element.Children then
						element.Children[i] = original
					else
						element[i] = original
					end
				end

				if what.Changes.Children then
					-- There was a change in the children of this element, replicate them.
					for child, changes in pairs(what.Changes.Children) do
						TraverseDifferences(changes, element.Children[child])
					end
				end

				if what.Changes.Properties then
					-- The properties have changed, reflect this change on the element's object.
					for prop, val in pairs(what.Changes.Properties.Changes) do
						element.Properties[prop] = val
						element.Object[prop] = val
					end
				end

				for _, v in pairs(what.Deletions) do
					local original = element[v]
					if original then
						original:Destroy()
						element[v] = nil
					end
				end
			end

			TraverseDifferences(changeList, interface.Elements)
		end
		-- Render all the components
		local function TraverseElements(elements)
			for name, element in pairs(elements) do
				element:Render()
				TraverseElements(element.Children)
			end
		end

		TraverseElements(interface.Elements)
	end
end)

return module