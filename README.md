# Lua Linear Algebra
<p align="center">
	<a href="https://github.com/Bytebit-Org/lua-linalg/actions">
        <img src="https://github.com/Bytebit-Org/lua-linalg/workflows/CI/badge.svg" alt="CI status" />
    </a>
	<a href="http://makeapullrequest.com">
		<img src="https://img.shields.io/badge/PRs-welcome-blue.svg" alt="PRs Welcome" />
	</a>
	<a href="https://opensource.org/licenses/MIT">
		<img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT" />
	</a>
	<a href="https://discord.gg/QEz3v8y">
		<img src="https://img.shields.io/badge/discord-join-7289DA.svg?logo=discord&longCache=true&style=flat" alt="Discord server" />
	</a>
</p>

A simple script to implement linear algebra functions not provided by the Lua standard API, developed especially for use on Roblox

## Installation
### Wally
[Wally](https://github.com/UpliftGames/wally/) users can install this package by adding the following line to their `Wally.toml` under `[dependencies]`:
```
linalg = "bytebit/linalg@1.0.0"
```

Then just run `wally install`.

### From model file
Model files are uploaded to every release as `.rbxmx` files. You can download the file from the [Releases page](https://github.com/Bytebit-Org/lua-linalg/releases) and load it into your project however you see fit.

### From model asset
New versions of the asset are uploaded with every release. The asset can be added to your Roblox Inventory and then inserted into your Place via Toolbox by getting it [here.](https://www.roblox.com/library/7881451885/linalg-Package)

## Documentation
---

### Matrix Functions
#### Matrix Instantiation Functions

<details>
<summary><code>linalg.matrix.new = function(rows)</code></summary>

Creates a new matrix

**Parameters:**
- `rows` (`array<array<number>>`)  
A (m x n) array of numbers to fill the matrix with

**Returns:**  
[t:(m x n) matrix] The new matrix

</details>

<details>
<summary><code>linalg.matrix.identity = function(n)</code></summary>

Creates an identity matrix of size (n x n)

**Parameters:**
- `n` (`number`)  
The size of the matrix

**Returns:**  
[t:(n x n) matrix] The identity matrix

</details>

<details>
<summary><code>linalg.matrix.zeros = function(m, n)</code></summary>

Creates a matrix of all zeros of size (m x n)

**Parameters:**
- `m` (`number`)
- `n` (`number`)

**Returns:**  
[t:(m x n) matrix] The zeros matrix

</details>

<details>
<summary><code>linalg.matrix.zerosLike = function(mat)</code></summary>

Creates a matrix of all zeros of the same size as the provided matrix

**Parameters:**
- `[t:(m`  
x n) matrix] mat The matrix to copy the size of

**Returns:**  
[t:(m x n) matrix] The zeros matrix

</details>

<details>
<summary><code>linalg.matrix.diagonal = function(values)</code></summary>

Creates a diagonal matrix with the values provided as the diagonal entries

**Parameters:**
- `values` (`array<number>`)  
An n-length array whose entries will be set as the diagonal entries

**Returns:**  
[t:(n x n) matrix] The resulting diagonal matrix

</details>

#### Matrix Classification Functions

<details>
<summary><code>linalg.matrix.isDiagonal = function(mat)</code></summary>

Determines whether a matrix is diagonal
Does not exclusively refer to square matrices
Refers strictly to whether all non-zero values are on the main diagonal (i.e., a_{ij} = 0 for all i, j where i ~= j)

**Parameters:**
- `[t:(m`  
x n) matrix] mat The matrix to check

**Returns:**  
`boolean`  
True if the matrix is diagonal, false otherwise

</details>

<details>
<summary><code>linalg.matrix.isUpperTriangular = function(mat)</code></summary>

Determines whether a matrix is upper triangular
Note that any non-square matrix will return false

**Parameters:**
- `[t:(m`  
x n) matrix] mat The matrix to check

**Returns:**  
`boolean`  
True if the matrix is upper triangular, false otherwise

</details>

<details>
<summary><code>linalg.matrix.isLowerTriangular = function(mat)</code></summary>

Determines whether a matrix is lower triangular
Note that any non-square matrix will return false

**Parameters:**
- `[t:(m`  
x n) matrix] mat The matrix to check

**Returns:**  
`boolean`  
True if the matrix is lower triangular, false otherwise

</details>

#### Basic Matrix Operation Functions

<details>
<summary><code>linalg.matrix.transpose = function(mat)</code></summary>

Creates a new matrix that is the transpose of the provided matrix

**Parameters:**
- `[t:`  
(m x n) matrix] mat The matrix to create the transpose of

**Returns:**  
[t: (n x m) matrix] The transpose of mat

</details>

<details>
<summary><code>linalg.matrix.expm = function(mat, numIterations)</code></summary>

Solves for e^mat
Defined as: e^A = \sum_{k=0}^{\infinity} \frac{1}{k!} A^k
Implemented in a naive way to approximate by using iterations
Runtime of O(n^3)

**Parameters:**
- `[t:(n`  
x n) matrix] mat The matrix to use as the exponent
- `numIterations` (`number`)  
The number of iterations to take the sum of the taylor series to

**Returns:**  
The matrix exponential approximation

</details>

### Vector Functions
#### Vector Instantiation Functions

<details>
<summary><code>linalg.vector.new = function(values)</code></summary>

Creates a new column vector

**Parameters:**
- `values` (`array<number>`)  
The values to have for the column vector

**Returns:**  
[t:(n x 1) matrix] The new column vector

</details>

<details>
<summary><code>linalg.vector.e = function(i, n)</code></summary>

Creates the standard basis vector i for R^n
That is, creates a vector of length n with all zeros except at index i which will have value 1

**Parameters:**
- `i` (`number`)  
The index of e
- `n` (`number`)  
The dimensionality of the vector

**Returns:**  
[t:(n x 1) matrix] The standard basis vector e_i in R^n

</details>

#### Vector Norm Functions

<details>
<summary><code>linalg.vector.norm.l1 = function(v)</code></summary>

The L1 norm of a vector
sum_i{|v_i|}

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector

**Returns:**  
`number`  
The resulting value

</details>

<details>
<summary><code>linalg.vector.norm.l2 = function(v)</code></summary>

The L2 norm of a vector
sqrt(sum_i{(v_i)^2})

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector

**Returns:**  
`number`  
The resulting value

</details>

<details>
<summary><code>linalg.vector.norm.linf = function(v)</code></summary>

The L-infinity norm of a vector
max{v}

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector

**Returns:**  
`number`  
The resulting value

</details>

#### Vector Inner Product Functions

<details>
<summary><code>linalg.vector.ip.dot = function(v1, v2)</code></summary>

Computes the standard dot product of two vectors
Defined as \sum_{i=0}^{n-1} v1[i] * v2[i]

**Parameters:**
- `[t:(n`  
x 1) matrix] v1 The first vector
- `[t:(n`  
x 1) matrix] v2 The second vector

**Returns:**  
`number`  
The result

</details>

#### Basic Vector Operation Functions

<details>
<summary><code>linalg.vector.project = function (v, u, innerProductFunc, normFunc)</code></summary>

Projects vector v onto vector space u
Defined as \sum_{i=0}^{m-1} <v, u[i]>/|u[i]|^2 * u[i]

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector to project onto u
- `[t:array<(n`  
x 1) matrix>] u The vector space to project v onto (can also be just one vector)
- `[t:function([(n`  
x 1) matrix], [(n x 1) matrix])?] innerProductFunc The inner product function to use; Defaults to the dot product
- `[t:function([(n`  
x 1) matrix])?] normFunc The norm function to use; Defaults to the L2 norm

**Returns:**  
The vector projection of v onto u

</details>

<details>
<summary><code>linalg.vector.unit = function(v, normFunc)</code></summary>

Gets the unit vector with the same direction as the provided vectr

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector with the appropriate direction
- `normFunc` (`function?`)  
The function to use as the norm; Defaults to the L2 norm

**Returns:**  
[t:(n x 1) matrix] The unit vector

</details>

<details>
<summary><code>linalg.vector.createArbitraryAxisRotationMatrix = function(v, theta)</code></summary>

Creates a matrix that rotates a vector about an arbitrary vector
Only works for 3 dimensions

**Parameters:**
- `[t:(n`  
x 1) matrix] v The vector to rotate about (should be a unit vector)
- `theta` (`number`)  
The angle to rotate by (in radians)

**Returns:**  
[t:nxn matrix] The resulting linear operator

</details>

#### Vector Space Functions

<details>
<summary><code>linalg.gramSchmidt = function (u, epsilon, dim, innerProductFunc, normFunc)</code></summary>

Creates an orthonormal basis for a dim-dimensional inner product space

**Parameters:**
- `[t:array<(n`  
x 1) matrix>] u The list of matrices to add to the basis (will be converted to unit vectors) (can be a single vector instead of an array)
- `epsilon` (`number?`)  
The minimum norm value for a vector to count to be added to the basis; Defaults to 0.01
- `[t:function([(n`  
x 1) matrix], [(n x 1) matrix])?] innerProductFunc The inner product function to use; Defaults to the dot product
- `[t:function([(n`  
x 1) matrix])?] normFunc The norm function to use; Defaults to the L2 norm

**Returns:**  
[t:array<(n x 1) matrix>] An orthonormal basis that includes the unit vectors of the original u

</details>