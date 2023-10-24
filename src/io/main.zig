pub const FileReader = @import("FileReader.zig").FileReader;
pub const S3FileReader = @import("S3FileReader.zig").S3FileReader;

pub const Reader = @import("Reader.zig").Reader;

test {
    _ = FileReader;
    _ = S3FileReader;
    _ = Reader;
}
