const std = @import("std");

const Endian = std.builtin.Endian;
const AttributeReader = @import("AttributeReader.zig").AttributeReader;
const AttributeWriter = @import("AttributeWriter.zig").AttributeWriter;

const DataType = @import("types").DataType;
const FieldRepetitionType = @import("types").FieldRepetitionType;
const ConvertedType = @import("types").ConvertedType;
const LogicalType = @import("types").LogicalType;

var default_allocator = std.heap.page_allocator;

pub const SchemaElement = struct {
    type: ?DataType = null,
    type_length: ?i32 = null,
    repetition_type: ?FieldRepetitionType = null,
    name: []const u8 = undefined,
    num_children: ?u32 = null,
    converted_type: ?ConvertedType = null,
    scale: ?i32 = null,
    precision: ?i32 = null,
    field_id: ?i32 = null,
    logicalType: ?LogicalType = null,

    children: ?[]SchemaElement = null,
    allocator: *std.mem.Allocator = &default_allocator,

    pub fn init(allocator: ?*std.mem.Allocator) !SchemaElement {
        return SchemaElement{ .allocator = allocator orelse &default_allocator };
    }

    // Each attribute is read in the sequence it is expected in the file.
    pub fn fromBuffer(self: *SchemaElement, buffer: []const u8) !usize {
        var reader = AttributeReader.init(buffer);

        var enum_value = try reader.readOptionalNumber(u8);
        if (enum_value != null) self.type = try DataType.fromValue(enum_value.?);

        self.type_length = try reader.readOptionalNumber(i32);

        enum_value = try reader.readOptionalNumber(u8);
        std.debug.print("Repetition type: {}\n", .{enum_value.?});
        if (enum_value != null) self.repetition_type = try FieldRepetitionType.fromValue(enum_value.?);

        self.name = try reader.readString();
        self.num_children = try reader.readOptionalNumber(u32);

        enum_value = try reader.readOptionalNumber(u8);
        if (enum_value != null) self.converted_type = try ConvertedType.fromValue(enum_value.?);

        self.scale = try reader.readOptionalNumber(i32);
        self.precision = try reader.readOptionalNumber(i32);
        self.field_id = try reader.readOptionalNumber(i32);

        enum_value = try reader.readOptionalNumber(u8);
        if (enum_value != null) self.logicalType = try LogicalType.fromValue(enum_value.?);

        if (self.num_children != null and self.num_children.? > 0) {
            std.debug.print("\nReading children\n", .{});
            var offset = reader.offset;
            self.children = try self.allocator.alloc(SchemaElement, self.num_children.?);
            for (self.children.?) |*child| {
                child.* = try SchemaElement.init(self.allocator);
                var bytesRead = try child.fromBuffer(reader.buffer[reader.offset..]);
                if (bytesRead > 0) offset += bytesRead;
            }
            return offset;
        }
        return reader.offset;
    }

    pub fn toBuffer(self: *SchemaElement) ![]u8 {
        var writer = AttributeWriter.init(self.allocator);

        if (self.type) |type_val| {
            try writer.writeNumber(u8, type_val.toValue(), true);
        } else {
            try writer.writeNumber(u8, null, true);
        }

        try writer.writeNumber(i32, self.type_length, self.type_length != null);

        if (self.repetition_type) |rep_type_val| {
            try writer.writeNumber(u8, rep_type_val.toValue(), true);
        } else {
            try writer.writeNumber(u8, null, true);
        }

        try writer.writeString(self.name, false);
        try writer.writeNumber(i32, self.num_children, self.num_children != null);

        if (self.converted_type) |conv_type_val| {
            try writer.writeNumber(u8, conv_type_val.toValue(), true);
        } else {
            try writer.writeNumber(u8, null, true);
        }

        try writer.writeNumber(i32, self.scale, self.scale != null);
        try writer.writeNumber(i32, self.precision, self.precision != null);
        try writer.writeNumber(i32, self.field_id, self.field_id != null);

        if (self.logicalType) |log_type_val| {
            try writer.writeNumber(u8, log_type_val.toValue(), true);
        } else {
            try writer.writeNumber(u8, null, true);
        }

        // Serialize children
        if (self.children) |children_array| {
            for (children_array) |child| {
                var childBuffer = try child.toBuffer();
                try writer.buffer.append(childBuffer);
            }
        }

        return writer.finalize();
    }

    pub fn deinit(self: *SchemaElement) void {
        // self.allocator.free(self.name);

        if (self.children != null) {
            for (self.children.?) |*child| {
                child.deinit();
            }
            // self.allocator.free(self.children);
        }
    }
};
