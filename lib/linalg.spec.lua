return function()
	local linalg = require(script.Parent.linalg)

	it("should handle matrix and scalar arithmetic correctly", function()
		local mat = linalg.matrix.new({
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        })

		expect(-mat).to.equal(linalg.matrix.new({
            {-1, -2, -3},
            {-4, -5, -6},
            {-7, -8, -9}
        }))
	end)
end