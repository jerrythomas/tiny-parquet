const std = @import("std");
const Endian = std.builtin.Endian;
const types = @import("thrift.types");

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

    // pub fn fromZigZag(n: anytype) anytype {
    //     return (n >> 1) ^ -(n & 1);
    // }

    pub fn readNumber(self: *CompactProtocolReader, comptime T: type) !T {
        const size = @sizeOf(T);

        try checkRemainingSize(self, size);

        const valueSlice = self.buffer[self.offset..][0..size];
        const value = std.mem.readInt(T, valueSlice, self.endian);

        self.offset += size;

        return value;
    }
};

test "CompactProtocolReader: should read a number" {}
