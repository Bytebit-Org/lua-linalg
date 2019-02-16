local linalg = {}

-- ARITHMETIC FUNCTIONS
local abs = math.abs
local floor = math.floor
local sqrt = math.sqrt

-- TRIG FUNCTIONS
local cos = math.cos
local sin = math.sin

--[[ ROW CLASS ]]--
local _rowClass = {}
local _newRow = function(values)
	local instance = setmetatable({}, _rowClass)

	rawset(instance, "_values", values)

	return instance
end
_rowClass.__index = function(row, key)
	if type(key) == "number" then
		return row._values[key]
	elseif key == "Length" then
		return #row._values
	end

	error("Unrecognized key: " .. tostring(key))
end
_rowClass.__newindex = function()
	error("Rows are immutable", 2)
end
_rowClass.__tostring = function(row)
	local result = ""

	for i = 1, row.Length do
		result = result .. row[i]
		if i < row.Length then
			result = result .. " "
		end
	end

	return result
end
_rowClass.__unm = function (row)
	if row.Length == 1 then
		return -1 * row[1]
	end

	local resultArray = {}

	for i = 1, row.Length do
		resultArray[i] = -1 * row[i]
	end

	return _newRow(resultArray)
end
_rowClass.__add = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left

		if row.Length == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar + rightScalar
		end

		error("Addition of a scalar to a row is undefined", 2)
	end

	if left.Length ~= right.Length then
		error("Addition of rows of different lengths is undefined", 2)
	end

	if left.Length == 1 then
		return left[1] + right[1]
	end

	local resultArray = {}

	for i = 1, left.Length do
		resultArray[i] = left[i] + right[i]
	end

	return _newRow(resultArray)
end
_rowClass.__sub = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left

		if row.Length == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar - rightScalar
		end

		error("Subtraction of a scalar to a row is undefined", 2)
	end

	if left.Length ~= right.Length then
		error("Subtraction of rows of different lengths is undefined", 2)
	end

	if left.Length == 1 then
		return left[1] - right[1]
	end

	local resultArray = {}

	for i = 1, left.Length do
		resultArray[i] = left[i] - right[i]
	end

	return _newRow(resultArray)
end
_rowClass.__mul = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		if row.Length == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar * rightScalar
		else
			local resultArray = {}

			for i = 1, row.Length do
				resultArray[i] = scalar * row[i]
			end

			return _newRow(resultArray)
		end
	elseif left.Length == 1 or right.Length == 1 then
		if left.Length == 1 and right.Length == 1 then
			return left[1] * right[1]
		elseif left.Length == 1 then
			return left[1] * right
		else
			return left * right[1]
		end
	end

	error("Multiplication of two rows is undefined", 2)
end
_rowClass.__div = function (left, right)
	if type(left) == "number" then
		error("Division of a scalar by a row is undefined", 2)
	elseif type(right) == "number" then
		if left.Length == 1 then
			return left[1] / right
		else
			local resultArray = {}

			for i = 1, left.Length do
				resultArray[i] = left[i] / right
			end

			return _newRow(resultArray)
		end
	elseif left.Length == 1 or right.Length == 1 then
		if left.Length == 1 and right.Length == 1 then
			return left[1] / right[1]
		elseif left.Length == 1 then
			error("Division of a scalar by a row is undefined", 2)
		else
			return left / right[1]
		end
	end

	error("Division of two rows is undefined", 2)
end
_rowClass.__mod = function (left, right)
	if type(left) == "number" then
		error("Modulo of a scalar by a row is undefined", 2)
	elseif type(right) == "number" then
		if left.Length == 1 then
			return left[1] % right
		else
			local resultArray = {}

			for i = 1, left.Length do
				resultArray[i] = left[i] % right
			end

			return _newRow(resultArray)
		end
	elseif left.Length == 1 or right.Length == 1 then
		if left.Length == 1 and right.Length == 1 then
			return left[1] % right[1]
		elseif left.Length == 1 then
			error("Modulo of a scalar by a row is undefined", 2)
		else
			return left % right[1]
		end
	end

	error("Modulo of two rows is undefined", 2)
end
_rowClass.__pow = function (left, right)
	if type(left) == "number" then
		if right.Length == 1 then
			return left ^ right[1]
		else
			error("Exponentiation of a scalar by a row is undefined", 2)
		end
	elseif type(right) == "number" then
		if left.Length == 1 then
			return left[1] ^ right
		else
			error("Exponentiation of a row by a scalar is undefined", 2)
		end
	elseif left.Length == 1 or right.Length == 1 then
		if left.Length == 1 and right.Length == 1 then
			return left[1] ^ right[1]
		elseif left.Length == 1 then
			error("Exponentiation of a scalar by a row is undefined", 2)
		else
			error("Exponentiation of a row by a scalar is undefined", 2)
		end
	end

	error("Exponentiation of two rows is undefined", 2)
end
_rowClass.__eq = function(left, right)
	if left.Length ~= right.Length then
		return false
	end

	for i = 1, left.Length do
		if left[i] ~= right[i] then
			return false
		end
	end

	return true
end

--[[ MATRIX CLASS ]]--
local _matrixClass = {}
local _newMatrix = function(rows)
	local rowInstances = {}
	for i = 1, #rows do
		rowInstances[i] = _newRow(rows[i])
	end

	local instance = setmetatable({}, _matrixClass)
	rawset(instance, "_rows", rowInstances)

	return instance
end
_matrixClass.__index = function(mat, key)
	if type(key) == "number" then
		return mat._rows[key]
	elseif key == "Shape" then
		return { #mat._rows, mat._rows[1].Length }
	elseif key == "T" then
		return linalg.matrix.transpose(mat)
	elseif key == "Unit" then
		if mat.Shape[2] == 1 then
			return linalg.vector.unit(mat)
		elseif mat.Shape[1] == mat.Shape[2] then
			return linalg.matrix.identity(mat.Shape[1])
		else
			error("Unit of a non-square matrix is undefined", 2)
		end
	elseif linalg.matrix[key] then
		if type(linalg.matrix[key]) == "function" then
			return function (...) return linalg.matrix[key](mat, ...) end
		end
	elseif linalg.vector[key] and mat.Shape[2] == 1 then
		if type(linalg.vector[key]) == "function" then
			return function (...) return linalg.vector[key](mat, ...) end
		end
	end

	error("Unrecognized key: " .. tostring(key))
end
_matrixClass.__newindex = function()
	error("Matrices are immutable", 2)
end
_matrixClass.__tostring = function(mat)
	local result = ""

	for i = 1, mat.Shape[1] do
		result = result .. tostring(mat[i])
		if i < mat.Shape[1] then
			result = result .. "\n"
		end
	end

	return result
end
_matrixClass.__unm = function(mat)
	local resultRows = {}

	for i = 1, mat.Shape[1] do
		resultRows[i] = {}
		for j = 1, mat.Shape[2] do
			resultRows[i][j] = -1 * mat[i][j]
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__add = function(left, right)
	if left.Shape[1] ~= right.Shape[1] or left.Shape[2] ~= right.Shape[2] then
		error(
			"Cannot add matrices of sizes (" ..
				left.Shape[1] .. " x " .. left.Shape[2] .. ") and (" .. right.Shape[1] .. " x " .. right.Shape[2] .. ")",
			2
		)
	end

	local resultRows = {}

	for i = 1, left.Shape[1] do
		resultRows[i] = {}
		for j = 1, left.Shape[2] do
			resultRows[i][j] = left[i][j] + right[i][j]
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__sub = function(left, right)
	if left.Shape[1] ~= right.Shape[1] or left.Shape[2] ~= right.Shape[2] then
		error(
			"Cannot subtract matrices of sizes (" ..
				left.Shape[1] .. " x " .. left.Shape[2] .. ") and (" .. right.Shape[1] .. " x " .. right.Shape[2] .. ")",
			2
		)
	end

	local resultRows = {}

	for i = 1, left.Shape[1] do
		resultRows[i] = {}
		for j = 1, left.Shape[2] do
			resultRows[i][j] = left[i][j] - right[i][j]
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__mul = function(left, right)
	local resultRows = {}

	if type(left) == "number" or type(right) == "number" then
		local mat = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		for i = 1, mat.Shape[1] do
			resultRows[i] = {}
			for j = 1, mat.Shape[2] do
				resultRows[i][j] = scalar * mat[i][j]
			end
		end
	else
		if left.Shape[2] ~= right.Shape[1] then
			error(
				"Cannot multiply matrices of sizes (" ..
					left.Shape[1] .. " x " .. left.Shape[2] .. ") and (" .. right.Shape[1] .. " x " .. right.Shape[2] .. ")",
				2
			)
		end

		for i = 1, left.Shape[1] do
			resultRows[i] = {}
			for j = 1, right.Shape[2] do
				resultRows[i][j] = 0
				for k = 1, left.Shape[2] do
					resultRows[i][j] = resultRows[i][j] + (left[i][k] * right[k][j])
				end
			end
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__div = function(mat, scalar)
	if type(mat) == "number" then
		error("Cannot divide a scalar by a matrix", 2)
	elseif type(scalar) ~= "number" then
		error("Cannot divide a matrix by a matrix", 2)
	end

	local resultRows = {}

	for i = 1, mat.Shape[1] do
		resultRows[i] = {}
		for j = 1, mat.Shape[2] do
			resultRows[i][j] = mat[i][j] / scalar
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__mod = function(mat, scalar)
	if type(mat) == "number" then
		error("Cannot compute modulus of a scalar by a matrix", 2)
	elseif type(scalar) ~= "number" then
		error("Cannot compute modulus of a matrix by a matrix", 2)
	end

	local resultRows = {}

	for i = 1, mat.Shape[1] do
		resultRows[i] = {}
		for j = 1, mat.Shape[2] do
			resultRows[i][j] = mat[i][j] % scalar
		end
	end

	return _newMatrix(resultRows)
end
_matrixClass.__pow = function(base, power)
	if type(base) ~= "number" and type(power) == "number" then
		if base.Shape[1] ~= base.Shape[2] then
			error("Cannot exponentiate a non-square matrix", 2)
		end
		if floor(power) ~= power or power < 1 then
			error("Cannot exponentiate a matrix by a non-positive non-integer", 2)
		end

		-- Runs in O(n^2 log_2(n)) time
		-- See https://www.hackerearth.com/practice/notes/matrix-exponentiation-1/
		local resultMatrix = linalg.matrix.identity(base.Shape[1])
		local curMat = base

		while power > 0 do
			if power % 2 == 1 then
				resultMatrix = resultMatrix * curMat
			end

			curMat = curMat * curMat
			power = floor(power / 2)
		end

		return resultMatrix
	elseif type(base) == "number" and type(power) ~= "number" then
		error("Cannot raise an arbitrary number to a matrix power", 2)
	else
		error("Cannot exponentiate a matrix by a matrix", 2)
		--TODO (You should be able to do exactly this)
	end
end
_matrixClass.__eq = function(left, right)
	if left.Shape[1] ~= right.Shape[1] or left.Shape[2] ~= right.Shape[2] then
		return false
	end

	for i = 1, left.Shape[1] do
		for j = 1, left.Shape[2] do
			if left[i][j] ~= right[i][j] then
				return false
			end
		end
	end

	return true
end

-- MATRIX FUNCTIONS
linalg.matrix = {}

--[[**
	Creates a new matrix

	@param [t:array<array<number>>] rows A (m x n) array of numbers to fill the matrix with

	@returns [t:(m x n) matrix] The new matrix
**--]]
linalg.matrix.new = function(rows)
	return _newMatrix(rows)
end

linalg.matrix.fromColumns = function(columnVectors)
	local resultRows = {}
	local n = columnVectors[1]["Shape"] and columnVectors[1].Shape[1] or #columnVectors[1]

	for i = 1, #columnVectors do
		for j = 1, n do
			if not resultRows[j] then
				resultRows[j] = {}
			end

			resultRows[j][i] = columnVectors[i][j] * 1 --*1 to ensure scalar functionality
		end
	end

	return _newMatrix(resultRows)
end

--[[**
	Creates an identity matrix of size (n x n)

	@param [t:number] n The size of the matrix

	@returns [t:(n x n) matrix] The identity matrix
**--]]
linalg.matrix.identity = function(n)
	local rows = {}

	for i = 1, n do
		rows[i] = {}
		for j = 1, n do
			rows[i][j] = i == j and 1 or 0
		end
	end

	return _newMatrix(rows)
end

--[[**
	Creates a matrix of all zeros of size (m x n)

	@param [t:number] m
	@param [t:number] n

	@returns [t:(m x n) matrix] The zeros matrix
**--]]
linalg.matrix.zeros = function(m, n)
	local rows = {}

	for i = 1, m do
		rows[i] = {}
		for j = 1, n do
			rows[i][j] = 0
		end
	end

	return _newMatrix(rows)
end

--[[**
	Creates a matrix of all zeros of the same size as the provided matrix

	@param [t:(m x n) matrix] mat The matrix to copy the size of

	@returns [t:(m x n) matrix] The zeros matrix
**--]]
linalg.matrix.zerosLike = function(mat)
	return linalg.matrix.zeros(mat.Shape[1], mat.Shape[2])
end

--[[**
	Creates a diagonal matrix with the values provided as the diagonal entries

	@param [t:array<number>] values An n-length array whose entries will be set as the diagonal entries

	@returns [t:(n x n) matrix] The resulting diagonal matrix
**--]]
linalg.matrix.diagonal = function(values)
	local resultRows = {}

	for i = 1, #values do
		resultRows[i] = {}
		for j = 1, #values do
			resultRows[i][j] = i == j and values[i] or 0
		end
	end

	return _newMatrix(resultRows)
end

--[[**
	Determines whether a matrix is diagonal
	Does not exclusively refer to square matrices
	Refers strictly to whether all non-zero values are on the main diagonal (i.e., a_{ij} = 0 for all i, j where i ~= j)

	@param [t:(m x n) matrix] mat The matrix to check

	@returns [t:boolean] True if the matrix is diagonal, false otherwise
**--]]
linalg.matrix.isDiagonal = function(mat)
	for i = 1, mat.Shape[1] do
		for j = 1, mat.Shape[2] do
			if i ~= j and mat[i][j] ~= 0 then
				return false
			end
		end
	end

	return true
end

--[[**
	Determines whether a matrix is upper triangular
	Note that any non-square matrix will return false

	@param [t:(m x n) matrix] mat The matrix to check

	@returns [t:boolean] True if the matrix is upper triangular, false otherwise
**--]]
linalg.matrix.isUpperTriangular = function(mat)
	if mat.Shape[1] ~= mat.Shape[2] then
		return false
	end

	for i = 1, mat.Shape[1] do
		for j = 1, mat.Shape[2] do
			if i > j and mat[i][j] ~= 0 then
				return false
			end
		end
	end

	return true
end

--[[**
	Determines whether a matrix is lower triangular
	Note that any non-square matrix will return false

	@param [t:(m x n) matrix] mat The matrix to check

	@returns [t:boolean] True if the matrix is lower triangular, false otherwise
**--]]
linalg.matrix.isLowerTriangular = function(mat)
	if mat.Shape[1] ~= mat.Shape[2] then
		return false
	end

	for i = 1, mat.Shape[1] do
		for j = 1, mat.Shape[2] do
			if i < j and mat[i][j] ~= 0 then
				return false
			end
		end
	end

	return true
end

--[[**
	Creates a new matrix that is the transpose of the provided matrix

	@param [t: (m x n) matrix] mat The matrix to create the transpose of

	@returns [t: (n x m) matrix] The transpose of mat
**--]]
linalg.matrix.transpose = function(mat)
	local resultRows = {}

	for i = 1, mat.Shape[1] do
		for j = 1, mat.Shape[2] do
			if not resultRows[j] then
				resultRows[j] = {}
			end

			resultRows[j][i] = mat[i][j]
		end
	end

	return _newMatrix(resultRows)
end

--[[**
	Solves for e^mat
	Defined as: e^A = \sum_{k=0}^{\infinity} \frac{1}{k!} A^k
	Implemented in a naive way to approximate by using iterations
	Runtime of O(n^3)

	@param [t:(n x n) matrix] mat The matrix to use as the exponent
	@param [t:number] numIterations The number of iterations to take the sum of the taylor series to

	@returns The matrix exponential approximation
**--]]
linalg.matrix.expm = function(mat, numIterations)
	if mat.Shape[1] ~= mat.Shape[2] then
		error("Cannot find the exponential of a non-square matrix", 2)
	end

	if not numIterations then
		numIterations = 128
	end

	local resultMatrix = linalg.matrix.identity(mat.Shape[1])
	local curMat = resultMatrix
	local factorial = 1

	for i = 1, numIterations do
		curMat = curMat * mat
		factorial = factorial * i

		resultMatrix = resultMatrix + ((1 / factorial) * curMat)
	end

	return resultMatrix
end

-- VECTOR FUNCTIONS
linalg.vector = {}

--[[**
	Creates a new column vector

	@param [t:array<number>] values The values to have for the column vector

	@returns [t:(n x 1) matrix] The new column vector
**--]]
linalg.vector.new = function(values)
	local rows = {}

	for i = 1, #values do
		rows[i] = {values[i]}
	end

	return _newMatrix(rows)
end

--[[**
	Creates the standard basis vector i for R^n
	That is, creates a vector of length n with all zeros except at index i which will have value 1

	@param [t:number] i The index of e
	@param [t:number] n The dimensionality of the vector

	@returns [t:(n x 1) matrix] The standard basis vector e_i in R^n
**--]]
linalg.vector.e = function(i, n)
	local rows = {}

	for j = 1, n do
		rows[j] = i == j and {1} or {0}
	end

	return _newMatrix(rows)
end

linalg.vector.norm = {}

--[[**
	The L1 norm of a vector
	sum_i{|v_i|}

	@param [t:(n x 1) matrix] v The vector

	@returns [t:number] The resulting value
**--]]
linalg.vector.norm.l1 = function(v)
	local sum = 0

	for i = 1, v.Shape[1] do
		sum = sum + abs(v[i][1])
	end

	return sum
end

--[[**
	The L2 norm of a vector
	sqrt(sum_i{(v_i)^2})

	@param [t:(n x 1) matrix] v The vector

	@returns [t:number] The resulting value
**--]]
linalg.vector.norm.l2 = function(v)
	local sum = 0

	for i = 1, v.Shape[1] do
		sum = sum + v[i]^2
	end

	return sqrt(sum)
end

--[[**
	The L-infinity norm of a vector
	max{v}

	@param [t:(n x 1) matrix] v The vector

	@returns [t:number] The resulting value
**--]]
linalg.vector.norm.linf = function(v)
	local maxComponentValue = 0

	for i = 1, v.Shape[1] do
		local componentValue = abs(v[i][1])
		if componentValue > maxComponentValue then
			maxComponentValue = componentValue
		end
	end

	return maxComponentValue
end

-- Inner product functions
linalg.vector.ip = {}

--[[**
	Computes the standard dot product of two vectors
	Defined as \sum_{i=0}^{n-1} v1[i] * v2[i]

	@param [t:(n x 1) matrix] v1 The first vector
	@param [t:(n x 1) matrix] v2 The second vector

	@returns [t:number] The result
**--]]
linalg.vector.ip.dot = function(v1, v2)
	if v1.Shape[1] ~= v2.Shape[1] then
		error("Cannot compute the dot product for vectors of unequal dimensions", 2)
	end
	if v1.Shape[2] ~= 1 or v2.Shape[2] ~= 1 then
		error("Cannot compute the dot product for non column vectors", 2)
	end

	local result = 0

	for i = 1, v1.Shape[1] do
		result = result + (v1[i] * v2[i])
	end

	return result
end

--[[**
	Projects vector v onto vector space u
	Defined as \sum_{i=0}^{m-1} <v, u[i]>/|u[i]|^2 * u[i]

	@param [t:(n x 1) matrix] v The vector to project onto u
	@param [t:array<(n x 1) matrix>] u The vector space to project v onto (can also be just one vector)
	@param [t:function([(n x 1) matrix], [(n x 1) matrix])?] innerProductFunc The inner product function to use; Defaults to the dot product
	@param [t:function([(n x 1) matrix])?] normFunc The norm function to use; Defaults to the L2 norm

	@returns The vector projection of v onto u
**--]]
linalg.vector.project = function (v, u, innerProductFunc, normFunc)
	if #u == 0 then -- u must be a single vector
		u = { u }
	end

	if u[1].Shape[1] ~= v.Shape[1] then
		error("Cannot project vectors of different dimensions", 2)
	end
	if u[1].Shape[2] ~= 1 or v.Shape[2] ~= 1 then
		error("Expected two vectors, not matrices", 2)
	end

	if not innerProductFunc then
		innerProductFunc = linalg.vector.ip.dot
	end
	if not normFunc then
		normFunc = linalg.vector.norm.l2
	end

	local result = linalg.matrix.zerosLike(v)

	for i = 1, #u do
		result = result + (innerProductFunc(v, u[i]) / normFunc(u[i])^2) * u[i]
	end

	return result
end

--[[**
	Gets the unit vector with the same direction as the provided vectr

	@param [t:(n x 1) matrix] v The vector with the appropriate direction
	@param [t:function?] normFunc The function to use as the norm; Defaults to the L2 norm

	@returns [t:(n x 1) matrix] The unit vector
**--]]
linalg.vector.unit = function(v, normFunc)
	if not normFunc then normFunc = linalg.vector.norm.l2 end
	return v / normFunc(v)
end

--[[**
	Creates a matrix that rotates a vector about an arbitrary vector
	Only works for 3 dimensions

	@param [t:(n x 1) matrix] v The vector to rotate about (should be a unit vector)
	@param [t:number] theta The angle to rotate by (in radians)

	@returns [t:nxn matrix] The resulting linear operator
**--]]
linalg.vector.createArbitraryAxisRotationMatrix = function(v, theta)
	if v.Shape[1] ~= 3 then
		error("Cannot create rotation matrix about arbitrary unit vector other than in R^3", 2)
	end

	local costheta = cos(theta)
	local sintheta = sin(theta)
	local versine = 1 - costheta
	local u = v.Unit

	return _newMatrix({
		{versine * u[1] ^ 2 + costheta, (versine * u[1] * u[2]) - (sintheta * u[3]), (versine * u[1] * u[3]) + (sintheta * u[2])},
		{(versine * u[1] * u[2]) + (sintheta * u[3]), versine * u[2] ^ 2 + costheta, (versine * u[2] * u[3]) - (sintheta * u[1])},
		{(versine * u[1] * u[3]) - (sintheta * u[2]), (versine * u[2] * u[3]) + (sintheta * u[1]), versine * u[3] ^ 2 + costheta}
	})
end

--[[ GENERAL FUNCTIONS ]]--
--[[**
	Creates an orthonormal basis for a dim-dimensional inner product space

	@param [t:array<(n x 1) matrix>] u The list of matrices to add to the basis (will be converted to unit vectors) (can be a single vector instead of an array)
	@param [t:number?] epsilon The minimum norm value for a vector to count to be added to the basis; Defaults to 0.01
	@param [t:function([(n x 1) matrix], [(n x 1) matrix])?] innerProductFunc The inner product function to use; Defaults to the dot product
	@param [t:function([(n x 1) matrix])?] normFunc The norm function to use; Defaults to the L2 norm

	@returns [t:array<(n x 1) matrix>] An orthonormal basis that includes the unit vectors of the original u
**--]]
linalg.gramSchmidt = function (u, epsilon, dim, innerProductFunc, normFunc)
	if #u == 0 then -- u must be just a single vector
		u = { u }
	end
	if not epsilon then
		epsilon = 0.01
	end
	if not dim then
		dim = u[1].Shape[1]
	end
	if not innerProductFunc then
		innerProductFunc = linalg.vector.ip.dot
	end
	if not normFunc then
		normFunc = linalg.vector.norm.l2
	end

	-- Normalize all elements in u
	local newU = {}
	for i = 1, #u do
		newU[i] = u[i].Unit
	end
	u = newU

	for i = 1, dim do
		local eiRows = {}
		for j = 1, dim do
			eiRows[j] = { i == j and 1 or 0 }
		end
		table.insert(u, _newMatrix(eiRows))
	end

	local basisVectors = { u[1].Unit }

	for i = 1, #u do
		local potentialBasisVector = u[i] - linalg.vector.project(u[i], basisVectors, innerProductFunc, normFunc)
		if normFunc(potentialBasisVector) >= epsilon then
			table.insert(basisVectors, potentialBasisVector.Unit)
		end

		if #basisVectors == dim then
			break
		end
	end

	return basisVectors
end

return linalg
