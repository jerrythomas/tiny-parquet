const std = @import("std");
const Endian = std.builtin.Endian;

pub const AttributeReader = struct {
    buffer: []const u8,
    offset: usize = 0,
    endian: Endian = Endian.Little,

    pub fn init(buffer: []const u8) AttributeReader {
        return AttributeReader{
            .buffer = buffer,
            .offset = 0,
            .endian = Endian.Little,
        };
    }

    pub fn hasAttribute(self: *AttributeReader) bool {
        const indicator = self.buffer[self.offset];
        self.offset += 1;
        return indicator != 0;
    }

    pub fn readNumber(self: *AttributeReader, comptime T: type) !T {
        const actualSize = @sizeOf(T);

        if (self.offset + actualSize > self.buffer.len) {
            return error.NotEnoughDataInBuffer;
        }

        // const valueSlice = self.buffer[self.offset .. self.offset + actualSize];
        const valueSlice = self.buffer[self.offset..][0..actualSize];
        const value = std.mem.readInt(T, valueSlice, self.endian);
        // const value = std.mem.readVarInt(T, valueSlice, self.endian);

        self.offset += actualSize;

        return value;
    }

    pub fn readOptionalNumber(self: *AttributeReader, comptime T: type) !?T {
        if (!self.hasAttribute()) return null;

        return try self.readNumber(T);
    }

    pub fn readString(self: *AttributeReader) ![]const u8 {
        const length = try self.readNumber(u32);

        if (self.offset + length > self.buffer.len) {
            return error.NotEnoughDataInBuffer;
        }
        const stringValue = self.buffer[self.offset .. self.offset + length];
        self.offset += length;

        return stringValue;
    }

    pub fn readOptionalString(self: *AttributeReader) !?[]const u8 {
        if (!self.hasAttribute()) return null;

        return try self.readString();
    }

    pub fn readBoolean(self: *AttributeReader) !bool {
        const value = try self.readNumber(u8);
        return value != 0;
    }
};
