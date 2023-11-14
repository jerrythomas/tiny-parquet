const std = @import("std");
const types = @import("thrift.types");

const Endian = std.builtin.Endian;
const ReaderState = types.State;
const MessageHeader = types.MessageHeader;
const StructHeader = types.FieldHeader; //StructHeader;
const FieldHeader = types.FieldHeader;
const MapHeader = types.MapHeader;
const ListHeader = types.ListHeader;
const SetHeader = types.ListHeader;

pub const Errors = error{
    BadVersion,
    NoProtocolVersionHeader,
    NotEnoughDataInBuffer,
};

pub const ProtocolReader = struct {
    ptr: *anyopaque,
    impl: *const Interface,
    endian: Endian.Little,

    pub const Interface = struct {
        readBytes: *const fn (ctx: *anyopaque, size: usize) Errors![]const u8,
        readNumber: *const fn (ctx: *anyopaque, bytes: u8) Errors!i64,
        readVariableInteger: *const fn (ctx: *anyopaque) Errors!i64,
        readDouble: *const fn (ctx: *anyopaque) Errors!f64,
        readStringOfSize: *const fn (ctx: *anyopaque, size: usize) Errors![]const u8,
        readString: *const fn (ctx: *anyopaque) Errors![]const u8,
        readBinary: *const fn (ctx: *anyopaque) Errors![]const u8,
        readBoolean: *const fn (ctx: *anyopaque) Errors!bool,

        readMessageBegin: *const fn (ctx: *anyopaque) Errors!MessageHeader,
        readMessageEnd: *const fn (ctx: *anyopaque) Errors!void,
        readStructBegin: *const fn (ctx: *anyopaque) Errors!StructHeader,
        readStructEnd: *const fn (ctx: *anyopaque) Errors!void,
        readFieldBegin: *const fn (ctx: *anyopaque) Errors!FieldHeader,
        readFieldEnd: *const fn (ctx: *anyopaque) Errors!void,
        readMapBegin: *const fn (ctx: *anyopaque) Errors!MapHeader,
        readMapEnd: *const fn (ctx: *anyopaque) Errors!void,
        readListBegin: *const fn (ctx: *anyopaque) Errors!ListHeader,
        readListEnd: *const fn (ctx: *anyopaque) Errors!void,
        readSetBegin: *const fn (ctx: *anyopaque) Errors!SetHeader,
        readSetEnd: *const fn (ctx: *anyopaque) Errors!void,

        getBytesRead: *const fn (ctx: *anyopaque) usize,
        getBoolValue: *const fn (ctx: *anyopaque) bool,
        getCurrentState: *const fn (ctx: *anyopaque) ReaderState,
        getCurrentFieldId: *const fn (ctx: *anyopaque) i16,
    };

    pub fn readNumber(self: ProtocolReader, comptime T: type) Errors!T {
        var valueSlice = try self.impl.readBytes(self.ptr, @sizeOf(T));
        return std.mem.readInt(T, valueSlice, self.endian);
    }
    pub fn readVariableInteger(self: ProtocolReader) Errors!i64 {
        return try self.impl.readVariableInteger(self.ptr);
    }
    pub fn readDouble(self: ProtocolReader) Errors!f64 {
        return try self.impl.readDouble(self.ptr);
    }
    pub fn readStringOfSize(self: ProtocolReader, size: usize) Errors![]const u8 {
        return try self.impl.readStringOfSize(self.ptr, size);
    }
    pub fn readString(self: ProtocolReader) Errors![]const u8 {
        return try self.impl.readString(self.ptr);
    }
    pub fn readBinary(self: ProtocolReader) Errors![]const u8 {
        return try self.impl.readBinary(self.ptr);
    }
    pub fn readBoolean(self: ProtocolReader) Errors!bool {
        return try self.impl.readBoolean(self.ptr);
    }
    pub fn readMessageBegin(self: ProtocolReader) Errors!MessageHeader {
        return try self.impl.readMessageBegin(self.ptr);
    }
    pub fn readMessageEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readMessageEnd(self.ptr);
    }
    pub fn readStructBegin(self: ProtocolReader) Errors!StructHeader {
        return try self.impl.readStructBegin(self.ptr);
    }
    pub fn readStructEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readStructEnd(self.ptr);
    }
    pub fn readFieldBegin(self: ProtocolReader) Errors!FieldHeader {
        return try self.impl.readFieldBegin(self.ptr);
    }
    pub fn readFieldEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readFieldEnd(self.ptr);
    }
    pub fn readMapBegin(self: ProtocolReader) Errors!MapHeader {
        return try self.impl.readMapBegin(self.ptr);
    }
    pub fn readMapEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readMapEnd(self.ptr);
    }
    pub fn readListBegin(self: ProtocolReader) Errors!ListHeader {
        return try self.impl.readListBegin(self.ptr);
    }
    pub fn readListEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readListEnd(self.ptr);
    }
    pub fn readSetBegin(self: ProtocolReader) Errors!SetHeader {
        return try self.impl.readSetBegin(self.ptr);
    }
    pub fn readSetEnd(self: ProtocolReader) Errors!void {
        return try self.impl.readSetEnd(self.ptr);
    }

    pub fn getBytesRead(self: ProtocolReader) usize {
        return self.impl.getBytesRead(self.ptr);
    }
    pub fn getBoolValue(self: ProtocolReader) bool {
        return self.impl.getBoolValue(self.ptr);
    }
    pub fn getCurrentState(self: ProtocolReader) ReaderState {
        return self.impl.getCurrentState(self.ptr);
    }
    pub fn getCurrentFieldId(self: ProtocolReader) i16 {
        return self.impl.getCurrentFieldId(self.ptr);
    }

    pub fn from(ctx: *anyopaque, comptime T: type) ProtocolReader {
        const self: *T = @ptrCast(@alignCast(ctx));
        return ProtocolReader{
            .ptr = self,
            .impl = &.{
                .readNumber = T.readNumber,
                .readBinary = T.readBinary,
                .readString = T.readString,
                .readStringOfSize = T.readStringOfSize,
                .readVariableInteger = T.readVariableInteger,
                .readDouble = T.readDouble,
                .readBoolean = T.readBoolean,
                .readMessageBegin = T.readMessageBegin,
                .readMessageEnd = T.readMessageEnd,
                .readStructBegin = T.readStructBegin,
                .readStructEnd = T.readStructEnd,
                .readFieldBegin = T.readFieldBegin,
                .readFieldEnd = T.readFieldEnd,
                .readMapBegin = T.readMapBegin,
                .readMapEnd = T.readMapEnd,
                .readListBegin = T.readListBegin,
                .readListEnd = T.readListEnd,
                .readSetBegin = T.readSetBegin,
                .readSetEnd = T.readSetEnd,
                .getBytesRead = T.getBytesRead,
                .getBoolValue = T.getBoolValue,
                .getCurrentState = T.getCurrentState,
                .getCurrentFieldId = T.getCurrentFieldId,
            },
        };
    }
};
