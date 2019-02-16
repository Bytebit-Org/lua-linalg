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

        expect(function() local _ = 1 + mat end).to.throw()
        expect(function() local _ = mat + 2 end).to.throw()

        expect(function() local _ = 1 - mat end).to.throw()
        expect(function() local _ = mat - 2 end).to.throw()

        expect(2 * mat).to.equal(linalg.matrix.new({
            {2, 4},
            {6, 8}
        }))
        expect(2 * mat).to.equal(mat * 2)

        expect(mat / 2).to.equal(linalg.matrix.new({
            {0.5, 1},
            {1.5, 2}
        }))
        expect(function() local _ = 2 / mat end).to.throw()

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
        expect(function() local _ = mat + linalg.matrix.new({ {1} }) end).to.throw()

        expect(mat - mat).to.equal(linalg.matrix.zeros(2, 2))
        expect(function() local _ = mat - linalg.matrix.new({ {1} }) end).to.throw()

        expect(mat * mat).to.equal(linalg.matrix.new({
            {7, 10},
            {15, 22}
        }))
        expect(function() local _ = mat * linalg.matrix.new({ {1} }) end).to.throw()
    end)

    it("should handle basic matrix operations correctly", function()
        local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })

        expect(mat.T).to.equal(linalg.matrix.new({
            {1, 3},
            {2, 4}
        }))

        expect(mat.Unit).to.equal(linalg.matrix.new({
            {1, 0},
            {0, 1}
        }))

        local expmResult = mat.expm()
        expect(expmResult[1][1]).to.be.near(51.968956198705)
        expect(expmResult[1][2]).to.be.near(74.736564567003)
        expect(expmResult[2][1]).to.be.near(112.1048468505)
        expect(expmResult[2][2]).to.be.near(164.07380304921)
    end)

    it("should create matrices correctly", function()
        expect(linalg.matrix.fromColumns({{1, 3}, {2, 4}})).to.equal(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }))
        expect(linalg.matrix.fromColumns({
            linalg.matrix.new({ {1}, {3} }),
            linalg.matrix.new({ {2}, {4} })
        })).to.equal(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }))

        expect(linalg.matrix.identity(2)).to.equal(linalg.matrix.new({
            {1, 0},
            {0, 1}
        }))

        expect(linalg.matrix.zeros(2, 2)).to.equal(linalg.matrix.new({
            {0, 0},
            {0, 0}
        }))

        expect(linalg.matrix.zerosLike(linalg.matrix.identity(2))).to.equal(linalg.matrix.new({
            {0, 0},
            {0, 0}
        }))

        expect(linalg.matrix.diagonal({1, 2})).to.equal(linalg.matrix.new({
            {1, 0},
            {0, 2}
        }))
    end)

    it("should classify matrices correctly", function()
        expect(linalg.matrix.identity(2).isDiagonal()).to.equal(true)

        expect(linalg.matrix.identity(2).isUpperTriangular()).to.equal(true)
        expect(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }).isUpperTriangular()).to.equal(false)

        expect(linalg.matrix.identity(2).isLowerTriangular()).to.equal(true)
        expect(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }).isLowerTriangular()).to.equal(false)
    end)

    it("should calculate norms correctly", function()
        local v = linalg.matrix.new({
            {1},
            {2}
        })

        expect(linalg.vector.norm.l1(v)).to.equal(3)

        expect(linalg.vector.norm.l2(v)).to.equal(math.sqrt(5))

        expect(linalg.vector.norm.linf(v)).to.equal(2)
    end)

    it("should calculate inner products correctly", function()
        local v1 = linalg.matrix.new({
            {1},
            {2}
        })
        local v2 = linalg.matrix.new({
            {2},
            {1}
        })
        local r3v = linalg.matrix.new({
            {1},
            {2},
            {3}
        })

        expect(linalg.vector.ip.dot(v1, v2)).to.equal(4)
        expect(function() local _ = linalg.vector.ip.dot(v1, r3v) end).to.throw()
    end)

    it("should handle basic vector operations correctly", function()
        local v = linalg.matrix.new({
            {1},
            {2}
        })
        local e1 = linalg.vector.e(1, 2)
        local e2 = linalg.vector.e(2, 2)
        local r3v = linalg.matrix.new({
            {1},
            {2},
            {3}
        })

        expect(v.project({e1, e2})).to.equal(v)
        expect(v.project({e1})).to.equal(e1)
        expect(function() local _ = v.project({r3v}) end).to.throw()

        expect(e1.Unit).to.equal(e1)
    end)

    it("should create proper rotation matrices", function()
        local e1 = linalg.vector.e(1, 3)
        local e2 = linalg.vector.e(2, 3)
        local rot180 = e1.createArbitraryAxisRotationMatrix(180)

        expect(rot180 * e1).to.equal(e1)

        do
            local rotatedE2 = rot180 * e2
            expect(rotatedE2[1][1]).to.equal(0)
            expect(rotatedE2[2][1]).to.be.near(-0.59846006905786)
            expect(rotatedE2[3][1]).to.be.near(-0.80115263573383)
        end
    end)

    it("should create a proper orthonormal basis", function()
        local e1 = linalg.vector.e(1, 2)
        local e2 = linalg.vector.e(2, 2)

        do
            local basis = linalg.gramSchmidt({ e1, e2 })
            expect(#basis).to.equal(2)
            expect(basis[1]).to.equal(e1)
            expect(basis[2]).to.equal(e2)
        end
    end)
end