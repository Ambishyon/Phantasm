return function()
	local Interface = require(script.Parent.Interface)
	local Fragment = require(script.Parent.Fragment)

	describe("fragment", function()
		it("should create a fragment without issue", function()
			local myInterface = Interface.new({Elements={}})
			local success, element = pcall(function()
				return Fragment.new("Fragment", {
					{ClassName="Frame",Properties={}};
					{ClassName="Frame",Properties={}};
				}, myInterface)
			end)
			expect(success and element ~= nil).to.be.ok()
		end)
	end)
end