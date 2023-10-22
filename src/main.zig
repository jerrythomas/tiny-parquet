const std = @import("std");
pub const types = @import("types");
pub const io = @import("io");
pub const meta = @import("meta");

pub const Parquet = @import("Parquet.zig").Parquet;

pub fn main() !void {
    var reader = try io.Reader.fromPath("spec/fixtures/users.parquet");
    var parquet = try Parquet.init(&reader);
    var metadata = try parquet.get_metadata();
    std.debug.print("\nMetadata\n", .{});
    std.debug.print("Version {}\n", .{metadata.version});
}
