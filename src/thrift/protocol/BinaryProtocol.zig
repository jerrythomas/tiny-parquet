const std = @import("std");
const mem = std.mem;

const BinaryProtocol = struct {
    // Class Variables (Converted to struct fields in Zig)
    VERSION_MASK: u32 = 0xffff0000,
    VERSION_1: u32 = 0x80010000,
    TYPE_MASK: u32 = 255,

    // readBool
    pub fn readBool(self: *BinaryProtocol) bool {
        const byte_value = self.readByte();
        return byte_value != 0;
    }

    // readByte
    pub fn readByte(self: *BinaryProtocol) i8 {
        var buffer: [1]i8 = undefined;
        self.trans.readAll(buffer[0..]); // Placeholder readAll method
        return buffer[0];
    }
};
