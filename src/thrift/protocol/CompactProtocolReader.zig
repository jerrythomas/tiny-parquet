const std = @import("std");
const Endian = std.builtin.Endian;
const types = @import("thrift.types");

const FieldHeader = types.FieldHeader;
const MapHeader = types.MapHeader;

const ThriftType = types.ThriftType;
const CompactType = types.CompactType;
const State = types.State;
const Structure = types.Structure;

const PROTOCOL_ID = 0x82;
const VERSION = 1;
const VERSION_MASK = 0x1f;
const TYPE_MASK = 0xe0;
const TYPE_BITS = 0x07;
const TYPE_SHIFT_AMOUNT = 5;

pub const CompactProtocolReader = struct {
    buffer: []const u8,
    offset: usize = 0,
    endian: Endian = Endian.Little,
    last_fid: i16 = 0,
    bool_value: bool = false,
    state: types.State = types.State.CLEAR,
    structs: []Structure = undefined,
    containers: []types.State = undefined,

    pub fn init(buffer: []const u8) CompactProtocolReader {
        return CompactProtocolReader{
            .buffer = buffer,
            .offset = 0,
            .endian = Endian.Little,
        };
    }

    pub fn checkRemainingSize(self: *CompactProtocolReader, size: usize) !void {
        if (self.offset + size > self.buffer.len) {
            return error.NotEnoughDataInBuffer;
        }
    }

    pub fn readBytes(self: *CompactProtocolReader, size: usize) ![]const u8 {
        try self.checkRemainingSize(size);
        const value = self.buffer[self.offset .. self.offset + size];
        self.offset += size;
        return value;
    }

    pub fn readNumber(self: *CompactProtocolReader, comptime T: type) !T {
        const valueSlice = try self.readBytes(@sizeOf(T));
        return std.mem.readInt(T, valueSlice, self.endian);
    }

    pub fn readVariableInteger(self: *CompactProtocolReader) !i64 {
        var result: i64 = 0;
        var shift: u6 = 0;

        while (true) {
            const byte = try self.readNumber(u8);

            result |= (@as(i64, byte) & 0x7f) << shift;

            if ((byte >> 7) == 0) return result;

            shift += 7;
        }
        return result;
    }

    pub fn readBoolean(self: *CompactProtocolReader) !bool {
        if (self.state == State.BOOL_READ) {
            // self.state = State.FIELD_READ;
            return self.bool_value;
        } else if (self.state == State.CONTAINER_READ) {
            var value = try self.readNumber(u8);
            return value == CompactType.TRUE.toValue();
        } else {
            return error.InvalidState;
        }
    }

    pub fn readDouble(self: *CompactProtocolReader) !f64 {
        const size = @sizeOf(f64);

        try checkRemainingSize(self, size);

        return @as(f64, @bitCast(try self.readNumber(u64)));
    }

    pub fn readStringOfSize(self: *CompactProtocolReader, size: usize) !?[]const u8 {
        if (size == 0) return null;
        return self.readBytes(size);
    }

    pub fn readString(self: *CompactProtocolReader) ![]const u8 {
        const length: usize = @abs(try self.readNumber(i32));
        var stringValue = try self.readStringOfSize(length);
        return stringValue.?;
    }

    pub fn readBinary(self: *CompactProtocolReader) ![]const u8 {
        return try self.readString();
    }

    pub fn readFieldBegin(self: *CompactProtocolReader) !FieldHeader {
        if (self.state != State.FIELD_READ) return error.InvalidState;

        var header = FieldHeader{};
        var field_type = try self.readNumber(u8);
        var compact_type = try CompactType.fromValue(field_type & 0x0f);

        header.field_type = compact_type.asThriftType();

        if (header.field_type == ThriftType.STOP) return header;
        const delta = field_type >> 4;
        if (delta == 0) {
            header.id = try self.readNumber(i16);
        } else {
            header.id = self.last_fid + delta;
        }
        self.last_fid = header.id;

        if (compact_type == CompactType.TRUE) {
            self.state = State.BOOL_READ;
            self.bool_value = true;
        } else if (compact_type == CompactType.FALSE) {
            self.state = State.BOOL_READ;
            self.bool_value = false;
        } else {
            self.state = State.VALUE_READ;
        }
        return header;
    }

    pub fn readFieldEnd(self: *CompactProtocolReader) !void {
        if (self.state == types.State.BOOL_READ or self.state == types.State.VALUE_READ) {
            self.state = types.State.FIELD_READ;
        } else {
            return error.InvalidState;
        }
    }

    pub fn readStructBegin(self: *CompactProtocolReader) !void {
        if (self.state != State.CLEAR and self.state != State.CONTAINER_READ and self.state != State.VALUE_READ) {
            return error.InvalidState;
        }
        self.structs.append(Structure{ .state = self.state, .last_fid = self.last_fid });
        self.state = State.FIELD_READ;
        self.last_fid = 0;
    }

    pub fn readStructEnd(self: *CompactProtocolReader) !void {
        if (self.state != State.FIELD_READ) return error.InvalidState;
        var last_item = self.__structs.pop();
        self.state = last_item.state;
        self.last_fid = last_item.last_fid;
    }

    pub fn readMapBegin(self: *CompactProtocolReader) !MapHeader {
        if (self.state != State.VALUE_READ and self.state != State.CONTAINER_READ) {
            return error.InvalidState;
        }
        var header = MapHeader{};
        header.size = try self.readNumber(u8);
        try self.checkRemainingSize(size);
        var kv_types: u8 = 0;
        if (header.size > 0) kv_types = try self.readNumber(u8);
        header.value_type = types.ThriftType.from(kv_types & 0x0f);
        header.key_type = types.ThriftType.from(kv_types >> 4);

        self.containers.append(self.state);
        self.state = State.CONTAINER_READ;
        return header;
    }

    pub fn readCollectionEnd(self: *CompactProtocolReader) !void {
        if (self.state != State.CONTAINER_READ) return error.InvalidState;
        self.state = self.containers.pop();
    }

    pub fn readSetEnd(self: *CompactProtocolReader) !void {
        return self.readCollectionEnd();
    }
    pub fn readListEnd(self: *CompactProtocolReader) !void {
        return self.readCollectionEnd();
    }
    pub fn readMapEnd(self: *CompactProtocolReader) !void {
        return self.readCollectionEnd();
    }
};

test "CompactProtocolReader: should throw error when state does not match" {
    var buffer = [_]u8{0x82};
    var reader = CompactProtocolReader.init(&buffer);

    var header = reader.readFieldBegin();
    try std.testing.expectEqual(header, error.InvalidState);
}

test "CompactProtocolReader: should read a boolean false field" {
    var buffer = [_]u8{0x82};
    var reader = CompactProtocolReader.init(&buffer);

    reader.state = State.FIELD_READ;
    var header = try reader.readFieldBegin();

    try std.testing.expect(header.field_type == ThriftType.BOOL);
    try std.testing.expect(header.id == 8);
    try std.testing.expect(header.name == null);

    try std.testing.expect(reader.last_fid == 8);
    try std.testing.expect(reader.state == State.BOOL_READ);
    try std.testing.expect(reader.bool_value == false);

    try reader.readFieldEnd();
    try std.testing.expect(reader.state == State.FIELD_READ);
}

test "CompactProtocolReader: should read a variable integer" {
    var buffer = [_]u8{ 0x80, 0x01, 0x80, 0x80, 0x01, 0x80, 0x80, 0x80, 0x01 };
    var reader = CompactProtocolReader.init(&buffer);
    var value = try reader.readVariableInteger();
    try std.testing.expect(value == 128);
    value = try reader.readVariableInteger();
    try std.testing.expect(value == 16384);
    value = try reader.readVariableInteger();
    try std.testing.expect(value == 2097152);
}
test "CompactProtocolReader: should read a boolean true field" {
    var buffer = [_]u8{0x61};
    var reader = CompactProtocolReader.init(&buffer);

    reader.state = State.FIELD_READ;
    var header = try reader.readFieldBegin();
    try std.testing.expect(header.field_type == ThriftType.BOOL);
    try std.testing.expect(header.id == 6);
    try std.testing.expect(header.name == null);

    try std.testing.expect(reader.last_fid == 6);
    try std.testing.expect(reader.state == State.BOOL_READ);
    try std.testing.expect(reader.bool_value == true);

    try reader.readFieldEnd();
    try std.testing.expect(reader.state == State.FIELD_READ);
}

test "CompactProtocolReader: should read a field number" {
    var buffer = [_]u8{ 0x03, 10, 0, 0, 0 };
    var reader = CompactProtocolReader.init(&buffer);

    reader.state = State.FIELD_READ;
    var header = try reader.readFieldBegin();
    try std.testing.expect(header.field_type == ThriftType.BYTE);
    try std.testing.expect(header.id == 10);
    try std.testing.expect(header.name == null);

    try std.testing.expect(reader.last_fid == 10);
    try std.testing.expect(reader.state == State.VALUE_READ);
    try reader.readFieldEnd();
    try std.testing.expect(reader.state == State.FIELD_READ);
}

test "CompactProtocolReader: should increment field id" {
    var buffer = [_]u8{0x24};
    var reader = CompactProtocolReader.init(&buffer);

    reader.state = State.FIELD_READ;
    reader.last_fid = 10;

    var header = try reader.readFieldBegin();
    try std.testing.expect(header.field_type == ThriftType.I16);
    try std.testing.expect(header.id == 12);
    try std.testing.expect(header.name == null);

    try std.testing.expect(reader.last_fid == 12);
    try std.testing.expect(reader.state == State.VALUE_READ);
    try std.testing.expect(reader.bool_value == false);

    try reader.readFieldEnd();
    try std.testing.expect(reader.state == State.FIELD_READ);
}
