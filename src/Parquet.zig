const std = @import("std");
const Endian = std.builtin.Endian;
const MetaData = @import("meta").MetaData;
const Reader = @import("storage").Reader;

pub const Parquet = struct {
    reader: *Reader = undefined,
    metadata: ?MetaData = null,

    pub fn init(reader: *Reader) !Parquet {
        var buf = try reader.read(4, -4);
        if (!std.mem.eql(u8, buf, "PAR1")) return error.InvalidParquetFile;

        return Parquet{ .reader = reader };
    }

    pub fn get_metadata(self: *Parquet) !MetaData {
        if (self.metadata != null) return self.metadata.?;

        var offset: i64 = -8;
        var buffer = try self.reader.read(4, offset);
        var size = std.mem.readVarInt(u32, buffer[0..4], Endian.Little);

        offset -= size + 4;
        buffer = try self.reader.read(size, offset);
        self.metadata = try MetaData.fromBuffer(buffer);

        return self.metadata.?;
    }
};
