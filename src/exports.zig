const std = @import("std");
const build_options = @import("build_options");
const FileType = @import("file_type.zig");

// Force tree-sitter symbols to be included by referencing them
// The actual tree_sitter_* symbols come from the linked C library
comptime {
    if (build_options.use_tree_sitter) {
        // Export our API functions
        @export(&syntax_get_file_types_count, .{ .name = "syntax_get_file_types_count" });

        // Reference tree-sitter parsers to force their inclusion
        _ = &force_include_parsers;
    }
}

// This function references all parsers to prevent dead code elimination
fn force_include_parsers() void {
    const file_types = @import("file_types.zig");
    const decls = @typeInfo(file_types).@"struct".decls;

    inline for (decls) |decl| {
        const file_type_info = @field(file_types, decl.name);
        // Only include if it doesn't have a custom parser field
        // (meaning it uses its own tree-sitter parser)
        if (!@hasField(@TypeOf(file_type_info), "parser")) {
            const parser = comptime FileType.Parser(decl.name);
            _ = parser;
        }
    }
}

fn syntax_get_file_types_count() callconv(.c) usize {
    return FileType.get_all().len;
}
