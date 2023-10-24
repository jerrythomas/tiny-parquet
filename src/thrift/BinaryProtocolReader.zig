const std = @import("std");
const Endian = std.builtin.Endian;
const types = @import("thrift.types");

const FieldHeader = types.FieldHeader;
const MapHeader = types.MapHeader;
const ListHeader = types.ListHeader;
const MessageHeader = types.MessageHeader;
const MessageType = types.MessageType;
const Types = types.ThriftType;

pub const BinaryProtocolReader = struct {
    buffer: []const u8,
    offset: usize = 0,
    endian: Endian = Endian.Little,
    strictRead: bool = false,
    strictWrite: bool = true,
    string_length_limit: ?usize = null,
    container_length_limit: ?usize = null,

    pub fn init(buffer: []const u8) BinaryProtocolReader {
        return BinaryProtocolReader{
            .buffer = buffer,
            .offset = 0,
            .endian = Endian.Little,
        };
    }

    pub fn hasAttribute(self: *BinaryProtocolReader) bool {
        const indicator = self.buffer[self.offset];
        self.offset += 1;
        return indicator != 0;
    }

    pub fn readNumber(self: *BinaryProtocolReader, comptime T: type) !T {
        const actualSize = @sizeOf(T);

        try checkRemainingSize(self, actualSize);

        const valueSlice = self.buffer[self.offset..][0..actualSize];
        const value = std.mem.readInt(T, valueSlice, self.endian);

        self.offset += actualSize;

        return value;
    }

    pub fn readOptionalNumber(self: *BinaryProtocolReader, comptime T: type) !?T {
        if (!self.hasAttribute()) return null;

        return try self.readNumber(T);
    }

    pub fn readDouble(self: *BinaryProtocolReader) !f64 {
        const size = @sizeOf(f64);

        try checkRemainingSize(self, size);

        return @as(f64, @bitCast(try self.readNumber(u64)));
    }

    pub fn readStringOfSize(self: *BinaryProtocolReader, size: usize) !?[]const u8 {
        try self.checkRemainingSize(size);

        if (size == 0) return null;
        const stringValue = self.buffer[self.offset .. self.offset + size];
        self.offset += size;

        return stringValue;
    }

    pub fn readString(self: *BinaryProtocolReader) ![]const u8 {
        const length: usize = @abs(try self.readNumber(i32));
        var stringValue = try self.readStringOfSize(length);
        return stringValue.?;
    }

    pub fn readBinary(self: *BinaryProtocolReader) ![]const u8 {
        return try self.readString();
    }

    pub fn readOptionalString(self: *BinaryProtocolReader) !?[]const u8 {
        if (!self.hasAttribute()) return null;

        return try self.readString();
    }

    pub fn readBoolean(self: *BinaryProtocolReader) !bool {
        const value = try self.readNumber(u8);
        return value != 0;
    }

    pub fn readMessageBegin(self: *BinaryProtocolReader) !MessageHeader {
        var sz = try self.readNumber(u32);
        var header = MessageHeader{};

        if (sz & (1 << 31) != 0) {
            const slice: []const u8 = @as([*]const u8, @ptrCast(&sz))[0..4];
            header.version = sz & types.VERSION_MASK;
            if (header.version != types.VERSION_1) return error.BadVersion;
            header.type = try MessageType.fromValue(@as(u8, @intCast(slice[0])) & types.TYPE_MASK);
            header.name = try self.readString();
        } else {
            if (self.strictRead) return error.NoProtocolVersionHeader;
            header.name = try self.readStringOfSize(sz);
            header.type = try MessageType.fromValue(try self.readNumber(u8));
        }
        header.sequence_id = try self.readNumber(i32);

        return header;
    }

    pub fn readMessageEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }
    pub fn readStructBegin(self: *BinaryProtocolReader) !void {
        _ = self;
    }
    pub fn readStructEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }

    pub fn readFieldBegin(self: *BinaryProtocolReader) !FieldHeader {
        var header = FieldHeader{};

        header.field_type = try Types.fromValue(try self.readNumber(u8));
        if (header.field_type == Types.STOP) return header;
        header.id = try self.readNumber(i16);
        return header;
    }

    pub fn readFieldEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }

    pub fn readMapBegin(self: *BinaryProtocolReader) !MapHeader {
        var header = MapHeader{};

        header.key_type = try Types.fromValue(try self.readNumber(u8));
        header.value_type = try Types.fromValue(try self.readNumber(u8));
        header.size = try self.readNumber(i32);

        try self.checkRemainingSize(@abs(header.size));
        return header;
    }

    pub fn readMapEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }

    pub fn readListBegin(self: *BinaryProtocolReader) !ListHeader {
        var header = ListHeader{};
        header.element_type = try Types.fromValue(try self.readNumber(u8));
        header.size = try self.readNumber(i32);

        try self.checkRemainingSize(@abs(header.size));
        return header;
    }

    pub fn readListEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }

    pub fn readSetBegin(self: *BinaryProtocolReader) !ListHeader {
        return try self.readListBegin();
    }

    pub fn readSetEnd(self: *BinaryProtocolReader) !void {
        _ = self;
    }

    pub fn checkRemainingSize(self: *BinaryProtocolReader, size: usize) !void {
        if (self.offset + size > self.buffer.len) {
            return error.NotEnoughDataInBuffer;
        }
    }
};

test "BinaryProtocolReader: should read a number" {
    const buffer = [_]u8{ 10, 0, 0, 0 };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readNumber(i32);
    try std.testing.expectEqual(value, 10);
    try std.testing.expectEqual(reader.offset, 4);
}

test "BinaryProtocolReader: should read an optional number" {
    const buffer = [_]u8{ 1, 10, 0, 0, 0 };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(value.?, 10);
    try std.testing.expectEqual(reader.offset, 5);
}

test "BinaryProtocolReader: should read an optional null number" {
    const buffer = [_]u8{ 0, 10, 0, 0, 0 };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(value, null);
    try std.testing.expectEqual(reader.offset, 1);
}

test "BinaryProtocolReader: should read a string of size" {
    const buffer = [_]u8{ 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readStringOfSize(11);

    try std.testing.expectEqualStrings(value.?, "Hello, Zig!");
    try std.testing.expectEqual(reader.offset, 11);
}

test "BinaryProtocolReader: should read a string" {
    const buffer = [_]u8{ 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readString();

    try std.testing.expectEqualStrings(value, "Hello, Zig!");
    try std.testing.expectEqual(reader.offset, 4 + 11);
}

test "BinaryProtocolReader: should read an optional string" {
    const buffer = [_]u8{ 1, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readOptionalString();

    try std.testing.expectEqualStrings(value.?, "Hello, Zig!");
    try std.testing.expectEqual(reader.offset, 1 + 4 + 11);
}

test "BinaryProtocolReader: should read an optional null string" {
    const buffer = [_]u8{ 0, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readOptionalString();

    try std.testing.expectEqual(value, null);
    try std.testing.expectEqual(reader.offset, 1);
}

test "BinaryProtocolReader: should read a boolean" {
    const buffer = [_]u8{1};
    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readBoolean();

    try std.testing.expect(value);
    try std.testing.expectEqual(reader.offset, 1);
}

test "BinaryProtocolReader: should read a double" {
    const expected: f64 = 3.14;
    const buffer = [_]u8{ 0x1f, 0x85, 0xeb, 0x51, 0xb8, 0x1e, 0x09, 0x40 };

    var reader = BinaryProtocolReader.init(&buffer);
    var value = try reader.readDouble();

    try std.testing.expectEqual(expected, value);
    try std.testing.expectEqual(reader.offset, 8);
}

test "BinaryProtocolReader: should read message header without version" {
    var reader = BinaryProtocolReader.init(&[_]u8{ 0, 0, 0, 0, 4, 2, 0, 0, 0 });
    var value = try reader.readMessageBegin();

    try std.testing.expectEqual(value.version, null);
    try std.testing.expectEqual(value.type, types.MessageType.ONEWAY);
    try std.testing.expectEqual(value.sequence_id, 2);
    try std.testing.expectEqual(value.name, null);

    reader = BinaryProtocolReader.init(&[_]u8{ 4, 0, 0, 0, 'z', 'i', 'g', '!', 1, 4, 0, 0, 0 });
    value = try reader.readMessageBegin();
    try std.testing.expectEqual(value.version, null);
    try std.testing.expectEqual(value.type, types.MessageType.CALL);
    try std.testing.expectEqual(value.sequence_id, 4);
    try std.testing.expectEqualStrings(value.name.?, "zig!");
}

test "BinaryProtocolReader: should read message header with version" {
    var reader = BinaryProtocolReader.init(&[_]u8{ 4, 0, 0x01, 0x80, 2, 0, 0, 0, 'h', 'i', 3, 0, 0, 0 });
    var value = try reader.readMessageBegin();

    try std.testing.expectEqual(value.version.?, 0x80010000);
    try std.testing.expectEqual(value.type, types.MessageType.ONEWAY);
    try std.testing.expectEqual(value.sequence_id, 3);
    try std.testing.expectEqualStrings(value.name.?, "hi");
}

test "BinaryProtocolReader: should read field header" {
    var reader = BinaryProtocolReader.init(&[_]u8{0});
    var value = try reader.readFieldBegin();

    try std.testing.expectEqual(value.field_type, types.ThriftType.STOP);
    try std.testing.expectEqual(value.id, 0);

    reader = BinaryProtocolReader.init(&[_]u8{ 1, 2, 0, 0, 0 });
    value = try reader.readFieldBegin();
    try std.testing.expectEqual(value.field_type, types.ThriftType.VOID);
    try std.testing.expectEqual(value.id, 2);
}

test "BinaryProtocolReader: should read map header" {
    var reader = BinaryProtocolReader.init(&[_]u8{ 11, 8, 4, 0, 0, 0, 0, 0, 0, 0 });
    var value = try reader.readMapBegin();

    try std.testing.expectEqual(value.key_type, types.ThriftType.STRING);
    try std.testing.expectEqual(value.value_type, types.ThriftType.I32);
    try std.testing.expectEqual(value.size, 4);
}

test "BinaryProtocolReader: should read list header" {
    var reader = BinaryProtocolReader.init(&[_]u8{ 4, 4, 0, 0, 0, 0, 0, 0, 0 });
    var value = try reader.readListBegin();

    try std.testing.expectEqual(value.element_type, types.ThriftType.DOUBLE);
    try std.testing.expectEqual(value.size, 4);
}

test "BinaryProtocolReader: should read set header" {
    var reader = BinaryProtocolReader.init(&[_]u8{ 6, 4, 0, 0, 0, 0, 0, 0, 0 });
    var value = try reader.readSetBegin();

    try std.testing.expectEqual(value.element_type, types.ThriftType.I16);
    try std.testing.expectEqual(value.size, 4);
}

test "BinaryProtocolReader: should read multiple values" {
    const buffer = [_]u8{ 0, 5, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', 0, 5, 0, 0, 0, 4, 0, 0, 0, 'Z', 'i', 'g', '!' };
    var reader = BinaryProtocolReader.init(&buffer);
    var stringValue = try reader.readOptionalString();
    try std.testing.expectEqual(stringValue, null);
    stringValue = try reader.readString();
    try std.testing.expectEqualStrings(stringValue.?, "Hello");
    var numberValue = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(numberValue, null);
    numberValue = try reader.readNumber(i32);
    try std.testing.expectEqual(numberValue.?, 5);
    stringValue = try reader.readString();
    try std.testing.expectEqualStrings(stringValue.?, "Zig!");
    try std.testing.expectEqual(reader.offset, buffer.len);
}
