pub const types = @import("types");
pub const enums = @import("enum");
pub const storage = @import("storage");
pub const meta = @import("meta");

pub fn main() !void {
    // try enums.test();
    // try fs.test();
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
    _ = @import("storage/Wrapper.spec.zig");
}
