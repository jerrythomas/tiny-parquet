const std = @import("std");

var default_allocator = std.heap.page_allocator;

const DataType = @import("enum").DataType;
const FieldRepetitionType = @import("enum").FieldRepetitionType;
const ConvertedType = @import("enum").ConvertedType;
const LogicalType = @import("enum").LogicalType;

pub const SchemaElement = struct {
    type: ?DataType = null, // Optional Type, so we make it nullable.
    type_length: ?i32 = null, // Optional i32, so we make it nullable.
    repetition_type: ?FieldRepetitionType = null, // Optional enum, so we make it nullable.
    name: []const u8, // Required string. Zig represents strings as slices of u8.
    num_children: ?i32 = null, // Optional i32, so we make it nullable.
    converted_type: ?ConvertedType = null, // Optional enum, so we make it nullable.
    scale: ?i32 = null, // Optional i32, so we make it nullable.
    precision: ?i32 = null, // Optional i32, so we make it nullable.
    field_id: ?i32 = null, // Optional i32, so we make it nullable.
    logicalType: ?LogicalType = null, // Optional enum, so we make it nullable.

    pub fn init() SchemaElement {
        return SchemaElement{};
    }
    pub fn fromBuffer(self: *SchemaElement, buffer: []const u8) !void {
        const reader = std.io.bufferedReader(buffer);

        // Assuming the order in the buffer is the same as the Thrift structure order
        self.type = DataType.fromValue(try reader.readIntLittle(i32));
        self.type_length = try reader.readIntLittle(i32);
        self.repetition_type = FieldRepetitionType.fromValue(try reader.readIntLittle(i32));
        self.name = try reader.readSliceUntilDelimiterOrEof('0'); // Assuming '0' as delimiter and null-terminated strings
        self.num_children = try reader.readIntLittle(i32);
        self.converted_type = ConvertedType.fromValue(try reader.readIntLittle(i32));
        self.scale = try reader.readIntLittle(i32);
        self.precision = try reader.readIntLittle(i32);
        self.field_id = try reader.readIntLittle(i32);
        self.logicalType = LogicalType.fromValue(try reader.readIntLittle(i32));
    }

    pub fn toBuffer(self: *SchemaElement, mem_allocater: ?*std.mem.Allocator) ![]u8 {
        const allocator = mem_allocater orelse &default_allocator;

        // Assuming fixed sizes for simplicity: 4 bytes for each i32 and 256 bytes for the name.
        // Adjust accordingly for your actual requirements.
        var buffer = try allocator.alloc(u8, 4 * 9 + 256);
        const writer = std.io.bufferedWriter(buffer);

        try writer.writeIntLittle(i32, self.type.?.value orelse 0);
        try writer.writeIntLittle(i32, self.type_length orelse 0);
        try writer.writeIntLittle(i32, self.repetition_type.?.value orelse 0);
        try writer.writeAll(self.name);
        try writer.writeIntLittle(i32, self.num_children orelse 0);
        try writer.writeIntLittle(i32, self.converted_type.?.value orelse 0);
        try writer.writeIntLittle(i32, self.scale orelse 0);
        try writer.writeIntLittle(i32, self.precision orelse 0);
        try writer.writeIntLittle(i32, self.field_id orelse 0);
        try writer.writeIntLittle(i32, self.logicalType.?.value orelse 0);

        return buffer;
    }
};
