return function()
    local linalg = require(script.Parent.linalg)

    it("should have immutable matrices", function()
        local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })

        expect(function() mat[1] = 1 end).to.throw()
        expect(function() mat[1][1] = 1 end).to.throw()
    end)

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
        expect(function() local _ = mat / mat end).to.throw()

        expect(mat % 2).to.equal(linalg.matrix.new({
            {1, 0},
            {1, 0}
        }))
        expect(function() local _ = mat % mat end).to.throw()

        expect(mat ^ 2).to.equal(mat * mat)
        expect(function() local _ = mat ^ 2.5 end).to.throw()
        expect(function() local _ = 2 ^ mat end).to.throw()
        expect(function() local _ = mat ^ mat end).to.throw()
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

    it("should handle arithmetic on rows correctly", function()
        local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })
        local v = linalg.vector.new({ 1, 2 })

        expect(-(mat[1])).to.equal(linalg.matrix.new({ {-1, -2} })[1])
        expect(-v).to.equal(linalg.vector.new({ -1, -2 }))
        expect(-v[1]).to.equal(-1)

        expect(v[1] + 1).to.equal(2)
        expect(v[1] + v[1]).to.equal(2)
        expect(function() local _ = mat[1] + 1 end).to.throw()
        expect(function() local _ = mat[1] + v[1] end).to.throw()

        expect(v[1] - 1).to.equal(0)
        expect(v[1] - v[1]).to.equal(0)
        expect(function() local _ = mat[1] - 1 end).to.throw()
        expect(function() local _ = mat[1] - v[1] end).to.throw()

        expect(2 * mat[1]).to.equal(linalg.matrix.new({ {2, 4} })[1])
        expect(v[1] * mat[1]).to.equal(mat[1])
        expect(2 * v[1]).to.equal(2)
        expect(v[1] * v[1]).to.equal(1)
        expect(function() local _ = mat[1] * mat[1] end).to.throw()

        expect(mat[2] / 2).to.equal(linalg.matrix.new({ {1.5, 2} })[1])
        expect(mat[1] / v[1]).to.equal(mat[1])
        expect(v[2] / 2).to.equal(1)
        expect(v[1] / v[1]).to.equal(1)
        expect(function() local _ = v[1] / mat[1] end).to.throw()
        expect(function() local _ = mat[1] / mat[1] end).to.throw()

        expect(mat[2] % 2).to.equal(linalg.matrix.new({ {1, 0} })[1])
        expect(mat[1] % v[2]).to.equal(linalg.matrix.new({ {1, 0} })[1])
        expect(v[1] % 2).to.equal(1)
        expect(v[1] % v[2]).to.equal(1)
        expect(function() local _ = v[1] % mat[1] end).to.throw()
        expect(function() local _ = mat[1] % mat[1] end).to.throw()

        expect(2 ^ v[2]).to.equal(4)
        expect(v[2] ^ 2).to.equal(4)
        expect(v[2] ^ v[2]).to.equal(4)
        expect(function() local _ = 2 ^ mat[1] end).to.throw()
        expect(function() local _ = mat[1] ^ 2 end).to.throw()
        expect(function() local _ = v[2] ^ mat[1] end).to.throw()
        expect(function() local _ = mat[1] ^ v[2] end).to.throw()
        expect(function() local _ = mat[1] ^ mat[1] end).to.throw()
    end)

    it("should handle basic matrix operations correctly", function()
        local mat = linalg.matrix.new({
            {1, 2},
            {3, 4}
        })
        local mat2x3 = linalg.matrix.new({
            {1, 2, 3},
            {4, 5, 6}
        })

        expect(mat.T).to.equal(linalg.matrix.new({
            {1, 3},
            {2, 4}
        }))

        expect(mat.Unit).to.equal(linalg.matrix.new({
            {1, 0},
            {0, 1}
        }))
        expect(function() local _ = mat2x3.Unit end).to.throw()

        local expmResult = mat.expm()
        expect(expmResult[1][1]).to.be.near(51.968956198705)
        expect(expmResult[1][2]).to.be.near(74.736564567003)
        expect(expmResult[2][1]).to.be.near(112.1048468505)
        expect(expmResult[2][2]).to.be.near(164.07380304921)

        expect(function() local _ = linalg.matrix.new({
            {1, 2, 3},
            {4, 5, 6}
        }).expm() end).to.throw()
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
        expect(linalg.matrix.new({
            {1, 0, 0},
            {0, 1, 0}
        }).isDiagonal()).to.equal(true)
        expect(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }).isDiagonal()).to.equal(false)

        expect(linalg.matrix.identity(2).isUpperTriangular()).to.equal(true)
        expect(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }).isUpperTriangular()).to.equal(false)
        expect(linalg.matrix.new({
            {1, 2, 3},
            {4, 5, 6}
        }).isUpperTriangular()).to.equal(false)

        expect(linalg.matrix.identity(2).isLowerTriangular()).to.equal(true)
        expect(linalg.matrix.new({
            {1, 2},
            {3, 4}
        }).isLowerTriangular()).to.equal(false)
        expect(linalg.matrix.new({
            {1, 2, 3},
            {4, 5, 6}
        }).isLowerTriangular()).to.equal(false)
    end)

    it("should calculate norms correctly", function()
        local v = linalg.vector.new({ 1, 2 })

        expect(linalg.vector.norm.l1(v)).to.equal(3)

        expect(linalg.vector.norm.l2(v)).to.equal(math.sqrt(5))

        expect(linalg.vector.norm.linf(v)).to.equal(2)
    end)

    it("should calculate inner products correctly", function()
        local I_2 = linalg.matrix.identity(2)
        local v1 = linalg.vector.new({ 1, 2 })
        local v2 = linalg.vector.new({ 2, 1 })
        local r3v = linalg.vector.new({ 1, 2, 3 })

        expect(linalg.vector.ip.dot(v1, v2)).to.equal(4)
        expect(function() local _ = linalg.vector.ip.dot(v1, I_2) end).to.throw()
        expect(function() local _ = linalg.vector.ip.dot(v1, r3v) end).to.throw()
    end)

    it("should handle basic vector operations correctly", function()
        local I_2 = linalg.matrix.identity(2)
        local v = linalg.vector.new({ 1, 2 })
        local e1 = linalg.vector.e(1, 2)
        local e2 = linalg.vector.e(2, 2)
        local r3v = linalg.vector.new({ 1, 2, 3 })

        expect(v.project({e1, e2})).to.equal(v)
        expect(v.project(e1)).to.equal(e1)
        expect(function() local _ = v.project(I_2) end).to.throw()
        expect(function() local _ = v.project(r3v) end).to.throw()

        expect(e1.Unit).to.equal(e1)
    end)

    it("should create proper rotation matrices", function()
        local e1 = linalg.vector.e(1, 3)
        local e2 = linalg.vector.e(2, 3)
        local rot180 = e1.createArbitraryAxisRotationMatrix(math.pi)

        expect(rot180 * e1).to.equal(e1)

        do
            local rotatedE2 = rot180 * e2
            expect(rotatedE2[1][1]).to.equal(0)
            expect(rotatedE2[2][1]).to.be.near(-1)
            expect(rotatedE2[3][1]).to.be.near(0)
        end

        expect(function() local _ = linalg.vector.e(1, 2).createArbitraryAxisRotationMatrix(0) end).to.throw()
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

        do
            local basis = linalg.gramSchmidt(e1)
            expect(#basis).to.equal(2)
            expect(basis[1]).to.equal(e1)
            expect(basis[2]).to.equal(e2)
        end
    end)
end