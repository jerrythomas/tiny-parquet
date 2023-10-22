const std = @import("std");
const Endian = std.builtin.Endian;
const MetaData = @import("meta").MetaData;
const Reader = @import("io").Reader;
var default_allocator = std.heap.page_allocator;

pub const Parquet = struct {
    reader: *Reader = undefined,
    metadata: MetaData = undefined,

    pub fn init(reader: *Reader) !Parquet {
        var buffer = try reader.read(4, -4);
        if (!std.mem.eql(u8, buffer, "PAR1")) return error.InvalidParquetFile;
        reader.allocator().free(buffer);

        return Parquet{ .reader = reader, .metadata = MetaData.init(reader.allocator()) };
    }

    pub fn get_metadata(self: *Parquet) !MetaData {
        if (self.metadata.version > 0) return self.metadata;

        var offset: i64 = -8;
        var buffer = try self.reader.read(4, offset);
        var size = std.mem.readVarInt(u32, buffer[0..4], Endian.Little);

        self.reader.allocator().free(buffer);
        offset -= size + 4;
        buffer = try self.reader.read(size, offset);

        _ = try self.metadata.fromBuffer(buffer);
        self.reader.allocator().free(buffer);
        return self.metadata;
    }
};
