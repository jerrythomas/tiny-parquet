const std = @import("std");
const Endian = std.builtin.Endian;
// const SchemaElement = @import("SchemaElement.zig");
// const RowGroup = @import("RowGroup.zig");
// const KeyValue = @import("KeyValue.zig");
// const ColumnOrder = @import("ColumnOrder.zig");
// const EncryptionAlgorithm = @import("EncryptionAlgorithm.zig");

pub const MetaData = struct {
    version: i32,
    // schema: []SchemaElement,
    // num_rows: i64,
    // row_groups: []RowGroup,
    // key_value_metadata: ?[]KeyValue,
    // created_by: ?[]u8,
    // column_orders: ?[]ColumnOrder,
    // encryption_algorithm: ?EncryptionAlgorithm,
    // footer_signing_key_metadata: ?[]u8,

    pub fn fromBuffer(buffer: []const u8) !MetaData {
        const version = std.mem.readVarInt(i32, buffer[0..4], Endian.Little);
        // const schema = try SchemaElement.fromBuffer(buffer[4..12]); // pseudo-slice
        // const num_rows = @as(i64, @intCast(@intFromLittle(u64, buffer[12..20])));
        // const row_groups = try RowGroup.fromBuffer(buffer[20..28]); // pseudo-slice
        // const key_value_metadata = KeyValue.fromBuffer(buffer[28..36]) orelse null; // pseudo-slice
        // const created_by = buffer[36..44]; // pseudo-slice for string
        // const column_orders = ColumnOrder.fromBuffer(buffer[44..52]) orelse null; // pseudo-slice
        // const encryption_algorithm = EncryptionAlgorithm.fromBuffer(buffer[52..60]) orelse null; // pseudo-slice
        // const footer_signing_key_metadata = buffer[60..68]; // pseudo-slice for binary data

        return MetaData{
            .version = version,
            // .schema = schema,
            // .num_rows = num_rows,
            // .row_groups = row_groups,
            // .key_value_metadata = key_value_metadata,
            // .created_by = created_by,
            // .column_orders = column_orders,
            // .encryption_algorithm = encryption_algorithm,
            // .footer_signing_key_metadata = footer_signing_key_metadata,
        };
    }
};
