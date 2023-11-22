const types = @import("thrift.types");

const FieldHeader = types.FieldHeader;
const MapHeader = types.MapHeader;
const ListHeader = types.ListHeader;
const ThriftType = types.ThriftType;
const CompactType = types.CompactType;
const MessageHeader = types.MessageHeader;
const State = types.State;
const Structure = types.Structure;

const BinaryProtocolReader = @import("BinaryProtocolReader.zig").BinaryProtocolReader;
const CompactProtocolReader = @import("CompactProtocolReader.zig").CompactProtocolReader;

pub const ProtocolReader = union(enum) {
    binary: BinaryProtocolReader,
    compact: CompactProtocolReader,

    pub fn from(ctx: *anyopaque, comptime T: type) ProtocolReader {
        const ref: *T = @ptrCast(@alignCast(ctx));
        switch (T) {
            BinaryProtocolReader => return ProtocolReader{ .binary = ref.* },
            CompactProtocolReader => return ProtocolReader{ .compact = ref.* },
            else => @compileError("Invalid type provided to ProtocolReader.from"),
        }
    }

    pub fn readNumber(self: *ProtocolReader, comptime T: type) !T {
        switch (self.*) {
            inline else => |*case| return try case.readNumber(T),
        }
    }

    pub fn readVariableInteger(self: *ProtocolReader) i64 {
        switch (self.*) {
            inline else => |*case| return case.readVariableInteger(),
        }
    }

    pub fn readBoolean(self: *ProtocolReader) bool {
        switch (self.*) {
            inline else => |*case| return case.readBoolean(),
        }
    }

    pub fn readDouble(self: *ProtocolReader) !f64 {
        switch (self.*) {
            inline else => |*case| return case.readDouble(),
        }
    }

    pub fn readStringOfSize(self: *ProtocolReader, size: usize) !?[]const u8 {
        switch (self.*) {
            inline else => |*case| return case.readStringOfSize(size),
        }
    }

    pub fn readString(self: *ProtocolReader) ![]const u8 {
        switch (self.*) {
            inline else => |*case| return case.readString(),
        }
    }

    pub fn readBinary(self: *ProtocolReader) ![]const u8 {
        switch (self.*) {
            inline else => |*case| return case.readBinary(),
        }
    }

    pub fn readFieldBegin(self: *ProtocolReader) !FieldHeader {
        switch (self.*) {
            inline else => |*case| return case.readFieldBegin(),
        }
    }

    pub fn readFieldEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readFieldEnd(),
        }
    }

    pub fn readStructBegin(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readStructBegin(),
        }
    }

    pub fn readStructEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readStructEnd(),
        }
    }

    pub fn readMapBegin(self: *ProtocolReader) !MapHeader {
        switch (self.*) {
            inline else => |*case| return case.readMapBegin(),
        }
    }

    pub fn readMapEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readMapEnd(),
        }
    }

    pub fn readCollectionBegin(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readCollectionBegin(),
        }
    }

    pub fn readCollectionEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readCollectionEnd(),
        }
    }

    pub fn readSetBegin(self: *ProtocolReader) !SetHeader {
        switch (self.*) {
            inline else => |*case| return case.readSetBegin(),
        }
    }

    pub fn readSetEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readSetEnd(),
        }
    }

    pub fn readListBegin(self: *ProtocolReader) !ListHeader {
        switch (self.*) {
            inline else => |*case| return case.readListBegin(),
        }
    }

    pub fn readListEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readListEnd(),
        }
    }

    pub fn readMessageBegin(self: *ProtocolReader) !MessageHeader {
        switch (self.*) {
            inline else => |*case| return case.readMessageBegin(),
        }
    }

    pub fn readMessageEnd(self: *ProtocolReader) !void {
        switch (self.*) {
            inline else => |*case| return case.readMessageEnd(),
        }
    }
};
