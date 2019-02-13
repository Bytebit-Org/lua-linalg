-- luacheck: ignore
globals = {
	-- global variables
	"script",

	-- global functions
	"unpack",

	-- math library
	"math.abs", "math.sqrt",
	"math.ceil", "math.floor",
	"math.min", "math.max",
	"math.cos", "math.sin", "math.tan", "math.atan2",

	-- test functions
	"it", "expect",
}

-- prevent max line lengths
max_line_length = false
max_code_line_length = false
max_string_line_length = false
max_comment_line_length = false