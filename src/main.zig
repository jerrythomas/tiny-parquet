const std = @import("std");
pub const types = @import("types");
pub const enums = @import("enum");
pub const storage = @import("storage");
pub const meta = @import("meta");

pub const Parquet = @import("Parquet.zig").Parquet;

pub fn main() !void {
    var reader = try storage.Reader.fromPath("spec/fixtures/users.parquet");
    var parquet = try Parquet.init(&reader);
    var metadata = try parquet.get_metadata();
    std.debug.print("Metadata\n", .{});
    std.debug.print("Version {}\n", .{metadata.version});
}

test {
    _ = @import("enum/BoundaryOrder.spec.zig");
    _ = @import("enum/CompressionCodec.spec.zig");
    _ = @import("enum/ConvertedType.spec.zig");
    _ = @import("enum/DataType.spec.zig");
    _ = @import("enum/Encoding.spec.zig");
    _ = @import("enum/FieldRepetitionType.spec.zig");
    _ = @import("enum/PageType.spec.zig");

    _ = @import("types/TimeUnit.spec.zig");
    _ = @import("types/LogicalType.spec.zig");

    _ = @import("storage/Local.spec.zig");
    _ = @import("storage/S3.spec.zig");
    _ = @import("storage/Reader.spec.zig");
}
