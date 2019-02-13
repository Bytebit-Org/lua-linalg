return function()
	local linalg = require(script.Parent.linalg)

	it("should handle matrix and scalar arithmetic correctly", function()
		local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })

		expect(-mat).to.equal(linalg.matrix.new({
            {-1, -2},
            {-3, -4}
        }))

        expect(2 * mat).to.equal(linalg.matrix.new({
            {2, 4},
            {6, 8}
        }))
        expect(2 * mat).to.equal(mat * 2)
	end)
end