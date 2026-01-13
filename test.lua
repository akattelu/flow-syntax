local ffi = require("ffi")

ffi.cdef[[
    size_t syntax_get_file_types_count();
]]

local lib = ffi.load("zig-out/lib/libsyntax.dylib")

local count = lib.syntax_get_file_types_count()
print("File types count: " .. tonumber(count))

assert(count > 0, "Expected at least one file type")
print("Test passed!")
