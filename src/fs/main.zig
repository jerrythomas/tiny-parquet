pub const FileSystem = @import("FileSystem.zig").FileSystem;
pub const LocalFileSystem = @import("LocalFileSystem.zig").LocalFileSystem;
pub const S3FileSystem = @import("S3FileSystem.zig").S3FileSystem;

// test {
//     _ = @import("LocalFileSystem.spec.zig");
//     _ = @import("S3FileSystem.spec.zig");
//     _ = @import("FileSystem.spec.zig");
// }
