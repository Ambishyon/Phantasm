return function()
	local Interface = require(script.Parent.Interface)
	local Element = require(script.Parent.Element)

	describe("element", function()
		it("should create an element without issue", function()
			local myInterface = Interface.new({Elements={}})
			local success, element = pcall(function()
				return Element.new("Element", {ClassName="Frame",Properties={}}, myInterface)
			end)
			expect(success and element ~= nil).to.be.ok()
		end)
	end)
end