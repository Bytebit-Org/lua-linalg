local linalg = {}

-- ARITHMETIC FUNCTIONS
local abs = math.abs
local ceil = math.ceil
local floor = math.floor
local sqrt = math.sqrt
local max = math.max
local min = math.min

-- TRIG FUNCTIONS
local cos = math.cos
local sin = math.sin
local tan = math.tan
local atan2 = math.atan2

local rowClass = {}
rowClass.__tostring = function(row)
	local result = ""

	for i = 1, #row do
		result = result .. row[i]
		if i < #row then
			result = result .. " "
		end
	end

	return result
end
rowClass.__unm = function (row)
	if #row == 1 then
		return -1 * row[1]
	end

	local resultArray = {}

	for i = 1, #row do
		resultArray[i] = -1 * row[i]
	end

	return setmetatable(resultArray, rowClass)
end
rowClass.__add = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		if #row == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar + rightScalar
		end

		error("Addition of a scalar to a row is undefined")
	end

	if #left ~= #right then
		error("Addition of rows of different lengths is undefined")
	end

	if #left == 1 then
		return left[1] + right[1]
	end
	
	local resultArray = {}

	for i = 1, #left do
		resultArray[i] = left[i] + right[i]
	end

	return setmetatable(resultArray, rowClass)
end
rowClass.__sub = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		if #row == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar - rightScalar
		end

		error("Subtraction of a scalar to a row is undefined")
	end

	if #left ~= #right then
		error("Subtraction of rows of different lengths is undefined")
	end

	if #left == 1 then
		return left[1] - right[1]
	end
	
	local resultArray = {}

	for i = 1, #left do
		resultArray[i] = left[i] - right[i]
	end

	return setmetatable(resultArray, rowClass)
end
rowClass.__mul = function (left, right)
	if type(left) == "number" or type(right) == "number" then
		local row = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		if #row == 1 then
			local leftScalar = type(left) == "number" and left or left[1]
			local rightScalar = type(right) == "number" and right or right[1]
			return leftScalar * rightScalar
		else
			local resultArray = {}
		
			for i = 1, #row do
				resultArray[i] = scalar * row[i]
			end
		
			return setmetatable(resultArray, rowClass)
		end
	end

	error("Multiplication of two rows is undefined")
end
rowClass.__div = function (left, right)
	if type(left) == "number" then
		error("Division of a scalar by a row is undefined")
	elseif type(right) == "number" then
		if #left == 1 then
			return left[1] / right
		else
			local resultArray = {}
		
			for i = 1, #left do
				resultArray[i] = left[i] / scalar
			end
		
			return setmetatable(resultArray, rowClass)
		end
	else
		error("Division of two rows is undefined")
	end
end
rowClass.__mod = function (left, right)
	if type(left) == "number" then
		error("Modulo of a scalar by a row is undefined")
	elseif type(right) == "number" then
		if #left == 1 then
			return left[1] % right
		else
			local resultArray = {}
		
			for i = 1, #left do
				resultArray[i] = left[i] % scalar
			end
		
			return setmetatable(resultArray, rowClass)
		end
	else
		error("Modulo of two rows is undefined")
	end
end
rowClass.__pow = function (left, right)
	if type(left) == "number" then
		if #right == 1 then
			return left ^ right[1]
		else
			error("Exponentiation of a scalar by a row is undefined")
		end
	elseif type(right) == "number" then
		if #left == 1 then
			return left[1] ^ right
		else
			error("Exponentiation of a row by a scalar is undefined")
		end
	else
		error("Exponentiation of two rows is undefined")
	end
end

local matrixClass = {}
matrixClass.__index = function(mat, key)
	if key == "T" then
		print("TODO: Implement transpose")
		rawset(mat, "T", mat)
		return mat.T
	elseif key == "Unit" then
		if mat._size[2] == 1 then
			rawset(mat, "Unit", linalg.vector.unit(mat))
		elseif mat._size[1] == mat._size[2] then
			rawset(mat, "Unit", linalg.matrix.identity(mat._size[1]))
		else
			error("Unit of a non-square matrix is undefined")
		end
		return mat.Unit
	end
end
matrixClass.__tostring = function(mat)
	local result = ""

	for i = 1, mat._size[1] do
		result = result .. tostring(mat[i])
		if i < mat._size[1] then
			result = result .. "\n"
		end
	end

	return result
end
matrixClass.__unm = function(mat)
	local resultRows = {}

	for i = 1, mat._size[1] do
		resultRows[i] = {}
		for j = 1, mat._size[2] do
			resultRows[i][j] = -1 * mat[i][j]
		end
	end

	return linalg.matrix.new(resultRows)
end
matrixClass.__add = function(left, right)
	if left._size[1] ~= right._size[1] or left._size[2] ~= right._size[2] then
		error(
			"Cannot add matrices of sizes (" ..
				left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")"
		)
	end

	local resultRows = {}

	for i = 1, left._size[1] do
		resultRows[i] = {}
		for j = 1, left._size[2] do
			resultRows[i][j] = left[i][j] + right[i][j]
		end
	end

	return linalg.matrix.new(resultRows)
end
matrixClass.__sub = function(left, right)
	if left._size[1] ~= right._size[1] or left._size[2] ~= right._size[2] then
		error(
			"Cannot subtract matrices of sizes (" ..
				left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")"
		)
	end

	local resultRows = {}

	for i = 1, left._size[1] do
		resultRows[i] = {}
		for j = 1, left._size[2] do
			resultRows[i][j] = left[i][j] - right[i][j]
		end
	end

	return linalg.matrix.new(resultRows)
end
matrixClass.__mul = function(left, right)
	local resultRows = {}

	if type(left) == "number" or type(right) == "number" then
		local mat = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		for i = 1, mat._size[1] do
			resultRows[i] = {}
			for j = 1, mat._size[2] do
				resultRows[i][j] = scalar * mat[i][j]
			end
		end
	else
		if left._size[2] ~= right._size[1] then
			error(
				"Cannot multiply matrices of sizes (" ..
					left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")"
			)
		end

		for i = 1, left._size[1] do
			resultRows[i] = {}
			for j = 1, left._size[2] do
				for k = 1, right._size[2] do
					resultRows[i][k] = left[i][j] * right[j][k]
				end
			end
		end
	end

	return linalg.matrix.new(resultRows)
end
matrixClass.__div = function(left, right)
	local resultRows = {}

	if type(left) == "number" or type(right) == "number" then
		local mat = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		for i = 1, mat._size[1] do
			resultRows[i] = {}
			for j = 1, mat._size[2] do
				resultRows[i][j] = mat[i][j] / scalar
			end
		end
	else
		error("Cannot divide a matrix by a matrix")
	end

	return linalg.matrix.new(resultRows)
end
matrixClass.__mod = function(left, right)
	local resultRows = {}

	if type(left) == "number" or type(right) == "number" then
		local mat = type(left) == "number" and right or left
		local scalar = type(left) == "number" and left or right

		for i = 1, mat._size[1] do
			resultRows[i] = {}
			for j = 1, mat._size[2] do
				resultRows[i][j] = mat[i][j] % scalar
			end
		end
	else
		error("Cannot divide a matrix by a matrix")
	end

	return linalg.matrix.new(resultRows)
end
-- Super naive. Definitely need to implement a better version.
-- See top answer here for what to implement soon: https://stackoverflow.com/questions/12311869/fast-matrix-exponentiation
matrixClass.__pow = function(mat, power)
	if type(power) ~= "number" or floor(power) ~= power or power < 1 then
		error("Cannot exponentiate a matrix by a non-positive non-integer")
	end

	local resultMatrix = mat

	for i = 2, power do
		resultMatrix = resultMatrix * mat
	end

	return resultMatrix
end
matrixClass.__eq = function(left, right)
	if left._size[1] ~= right._size[1] or left._size[2] ~= right._size[2] then
		return false
	end

	for i = 1, left._size[1] do
		for j = 1, left._size[2] do
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
	local rowInstances = {}
	for i = 1, #rows do
		rowInstances[i] = setmetatable(rows[i], rowClass)
	end

	local instance = setmetatable(rowInstances, matrixClass)
	rawset(instance, "_size", { #rows, #rows[1] })

	return instance
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

	return linalg.matrix.new(rows)
end

-- VECTOR FUNCTIONS
linalg.vector = {}

linalg.vector.norm = {}

--[[**
	The L1 norm of a vector
	sum_i{|v_i|}
	
	@param [t:(n x 1) matrix] v The vector
	
	@returns [t:number] The resulting value
**--]]
linalg.vector.norm.l1 = function(v)
	local sum = 0

	for i = 1, #v do
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

	for i = 1, #v do
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

	for i = 1, #v do
		local componentValue = abs(v[i][1])
		if componentValue > maxComponentValue then
			maxComponentValue = componentValue
		end
	end

	return maxComponentValue
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
	Rotates a vector about an arbitrary vector
	Only works for 3 dimensions
	
	@param [t:(n x 1) matrix] u The vector to rotate v about (should be a unit vector)
	@param [t:number] theta The degrees to rotate by
	
	@returns [t:nxn matrix] The resulting linear operator
**--]]
linalg.vector.createRotationMatrix = function(u, theta)
	if #u > 3 then
		error("Cannot create rotation matrix about arbitrary unit vector other than in R^3")
	end

	local costheta = cos(theta)
	local sintheta = sin(theta)
	local versine = 1 - costheta

	return linalg.matrix.new({
		{versine * u[1] ^ 2, (versine * u[1] * u[2]) - (sintheta * u[3]), (versine * u[1] * u[3]) + (sintheta * u[2])},
		{(versine * u[1] * u[2]) + (sintheta * u[3]), versine * u[2] ^ 2, (versine * u[2] * u[3]) - (sintheta * u[1])},
		{(versine * u[1] * u[3]) - (sintheta * u[2]), (versine * u[2] * u[3]) + (sintheta * u[1]), versine * u[3] ^ 2}
	})
end

return linalg
