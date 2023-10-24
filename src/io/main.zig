pub const Reader = @import("Reader.zig").Reader;
pub const FileReader = @import("FileReader.zig").FileReader;
pub const S3FileReader = @import("S3FileReader.zig").S3FileReader;

test {
    _ = Reader;
}
