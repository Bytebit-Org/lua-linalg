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

        expect(mat / 2).to.equal(linalg.matrix.new({
            {0.5, 1},
            {1.5, 2}
        }))

        expect(mat % 2).to.equal(linalg.matrix.new({
            {1, 0},
            {1, 0}
        }))

        expect(mat ^ 2).to.equal(mat * mat)
    end)
        
	it("should handle matrix and matrix arithmetic correctly", function()
		local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })

        expect(mat + mat).to.equal(mat * 2)

        expect(mat - mat).to.equal(linalg.matrix.zeros(2, 2))
        
        expect(mat * mat).to.equal(linalg.matrix.new({
            {7, 10},
            {15, 22}
        }))
    end)
    
    it("should rotate vectors appropriately", function()
    end)
end