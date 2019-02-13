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

-- MATRIX FUNCTIONS
linalg.matrix = {}

local matrixClass = {}
matrixClass.__index = function (mat, key)
	if type(key) == "number" then
		return mat._rows[key]
	elseif key == "T" then
		print("TODO: Implement transpose")
		return mat
	end
end
matrixClass.__tostring = function (mat)
	local result = ""
	
	for i = 1, mat._size[1] do
		for j = 1, mat._size[2] do
			result = result .. mat[i][j]
			if j < mat._size[2] then
				result = result .. " "
			end
		end
		if i < mat._size[1] then
			result = result .. "\n"
		end
	end
	
	return result
end
matrixClass.__unm = function (mat)
	local resultRows = {}
	
	for i = 1, mat._size[1] do
		resultRows[i] = {}
		for j = 1, mat._size[2] do
			resultRows[i][j] = -1 * mat[i][j]
		end
	end
	
	return linalg.matrix.new(resultRows)
end
matrixClass.__add = function (left, right)
	if left._size[1] ~= right._size[1] or left._size[2] ~= right._size[2] then
		error("Cannot add matrices of sizes (" .. left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")")
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
matrixClass.__sub = function (left, right)
	if left._size[1] ~= right._size[1] or left._size[2] ~= right._size[2] then
		error("Cannot subtract matrices of sizes (" .. left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")")
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
matrixClass.__mul = function (left, right)
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
			error("Cannot multiply matrices of sizes (" .. left._size[1] .. " x " .. left._size[2] .. ") and (" .. right._size[1] .. " x " .. right._size[2] .. ")")
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
matrixClass.__div = function (left, right)
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
matrixClass.__mod = function (left, right)
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
matrixClass.__pow = function (mat, power)
	if type(power) ~= "number" or floor(power) ~= power or power < 1 then
		error("Cannot exponentiate a matrix by a non-positive non-integer")
	end
	
	local resultMatrix = mat
	
	for i = 2, power do
		resultMatrix = resultMatrix * mat
	end
		
	return resultMatrix
end
matrixClass.__eq = function (left, right)
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

--[[**
	Creates a new matrix
	
	@param [t:array<array<number>>] rows A (m x n) array of numbers to fill the matrix with
	
	@returns [t:(m x n) matrix] The new matrix
**--]]
linalg.matrix.new = function (rows)
	local instance = setmetatable({}, matrixClass)
	
	instance._rows = rows
	instance._size = { #rows, #rows[1] }
	
	return instance
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
linalg.vector.norm.l2 = function (v)
	local sum = 0
	
	for i = 1, #v do
		sum = sum + abs(v[i])
	end
	
	return sum
end

--[[**
	The L2 norm of a vector
	sqrt(sum_i{(v_i)^2})
	
	@param [t:(n x 1) matrix] v The vector
	
	@returns [t:number] The resulting value
**--]]
linalg.vector.norm.l2 = function (v)
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
linalg.vector.norm.linf = function (v)
	return max(unpack(v))
end

--[[**
	Rotates a vector about an arbitrary vector
	Only works for 3 dimensions
	
	@param [t:(n x 1) matrix] u The vector to rotate v about (should be a unit vector)
	@param [t:number] theta The degrees to rotate by
	
	@returns [t:nxn matrix] The resulting linear operator
**--]]
linalg.vector.createRotationMatrix = function (u, theta)
	if #u > 3 then
		error("Cannot create rotation matrix about arbitrary unit vector other than in R^3")
	end
	
	local costheta = cos(theta)
	local sintheta = sin(theta)
	local versine = 1 - costheta
	
	return {
		{ versine * u[1]^2, (versine * u[1] * u[2]) - (sintheta * u[3]), (versine * u[1] * u[3]) + (sintheta * u[2]) },
		{ (versine * u[1] * u[2]) + (sintheta * u[3]), versine * u[2]^2, (versine * u[2] * u[3]) - (sintheta * u[1]) },
		{ (versine * u[1] * u[3]) - (sintheta * u[2]), (versine * u[2] * u[3]) + (sintheta * u[1]), versine * u[3]^2 }
	}
end

return linalg