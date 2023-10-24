const std = @import("std");

pub const MessageType = enum(u8) {
    CALL = 1,
    REPLY = 2,
    EXCEPTION = 3,
    ONEWAY = 4,

    pub fn fromValue(value: u8) !MessageType {
        if (value == 0 or value > 4) return error.InvalidMessageTypeValue;
        return @as(MessageType, @enumFromInt(value));
    }

    pub fn toValue(self: MessageType) u8 {
        return @intFromEnum(self);
    }
};

test "MessageType: should convert integer to enum value" {
    try std.testing.expectEqual(MessageType.fromValue(1), MessageType.CALL);
    try std.testing.expectEqual(MessageType.fromValue(2), MessageType.REPLY);
    try std.testing.expectEqual(MessageType.fromValue(3), MessageType.EXCEPTION);
    try std.testing.expectEqual(MessageType.fromValue(4), MessageType.ONEWAY);
}

test "MessageType: should convert from enum" {
    try std.testing.expect(MessageType.CALL.toValue() == 1);
    try std.testing.expect(MessageType.REPLY.toValue() == 2);
    try std.testing.expect(MessageType.EXCEPTION.toValue() == 3);
    try std.testing.expect(MessageType.ONEWAY.toValue() == 4);
}

test "MessageType: should throw InvalidMessageTypeValue" {
    var result = MessageType.fromValue(5);
    try std.testing.expectEqual(result, error.InvalidMessageTypeValue);
    result = MessageType.fromValue(0);
    try std.testing.expectEqual(result, error.InvalidMessageTypeValue);
}
