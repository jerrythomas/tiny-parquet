const std = @import("std");
const Endian = std.builtin.Endian;
const AttributeReader = @import("AttributeReader.zig").AttributeReader;
var default_allocator = std.heap.page_allocator;
const SchemaElement = @import("SchemaElement.zig").SchemaElement;
// const RowGroup = @import("RowGroup.zig");
// const KeyValue = @import("KeyValue.zig");
// const ColumnOrder = @import("ColumnOrder.zig");
// const EncryptionAlgorithm = @import("EncryptionAlgorithm.zig");

pub const MetaData = struct {
    version: i32 = 0,
    schema: SchemaElement = undefined,
    num_rows: i64 = 0,
    // row_groups: []RowGroup,
    // key_value_metadata: ?[]KeyValue,
    // created_by: ?[]u8,
    // column_orders: ?[]ColumnOrder,
    // encryption_algorithm: ?EncryptionAlgorithm,
    // footer_signing_key_metadata: ?[]u8,

    allocator: *std.mem.Allocator = &default_allocator,

    pub fn init(allocator: ?*std.mem.Allocator) MetaData {
        return MetaData{ .allocator = allocator orelse &default_allocator };
    }

    pub fn fromBuffer(self: *MetaData, buffer: []const u8) !usize {
        var reader = AttributeReader.init(buffer);
        self.version = try reader.readNumber(i32);

        self.schema = try SchemaElement.init(self.allocator);
        var bytesRead = try self.schema.fromBuffer(buffer[reader.offset..]);
        reader.offset += bytesRead;
        self.num_rows = try reader.readNumber(i64);
        // const row_groups = try RowGroup.fromBuffer(buffer[20..28]); // pseudo-slice
        // const key_value_metadata = KeyValue.fromBuffer(buffer[28..36]) orelse null; // pseudo-slice
        // const created_by = buffer[36..44]; // pseudo-slice for string
        // const column_orders = ColumnOrder.fromBuffer(buffer[44..52]) orelse null; // pseudo-slice
        // const encryption_algorithm = EncryptionAlgorithm.fromBuffer(buffer[52..60]) orelse null; // pseudo-slice
        // const footer_signing_key_metadata = buffer[60..68]; // pseudo-slice for binary data

        // return MetaData{
        //     .version = version,
        // .schema = schema,
        // .num_rows = num_rows,
        // .row_groups = row_groups,
        // .key_value_metadata = key_value_metadata,
        // .created_by = created_by,
        // .column_orders = column_orders,
        // .encryption_algorithm = encryption_algorithm,
        // .footer_signing_key_metadata = footer_signing_key_metadata,
        // };
        return reader.offset;
    }
};
