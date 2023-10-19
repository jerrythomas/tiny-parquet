pub const enums = @import("enum");
pub const fs = @import("fs");

pub fn main() !void {
    // try enums.test();
    // try fs.test();
}
test {
    _ = @import("enum/BoundaryOrder.spec.zig");
    _ = @import("enum/CompressionCodec.spec.zig");
    _ = @import("enum/DataType.spec.zig");
    _ = @import("enum/Encoding.spec.zig");
    _ = @import("enum/FieldRepetitionType.spec.zig");
    _ = @import("enum/PageType.spec.zig");
    _ = @import("enum/StorageType.spec.zig");

    _ = @import("fs/LocalFileSystem.spec.zig");
    _ = @import("fs/S3FileSystem.spec.zig");
    _ = @import("fs/FileSystem.spec.zig");
}
