const std = @import("std");

pub const State = enum(u8) {
    CLEAR = 0,
    FIELD_WRITE = 1,
    VALUE_WRITE = 2,
    CONTAINER_WRITE = 3,
    BOOL_WRITE = 4,
    FIELD_READ = 5,
    CONTAINER_READ = 6,
    VALUE_READ = 7,
    BOOL_READ = 8,

    pub fn fromValue(value: u8) !State {
        if (value > 8) return error.InvalidOperationTypeValue;
        return @as(State, @enumFromInt(value));
    }

    pub fn toValue(self: State) u8 {
        return @intFromEnum(self);
    }
};

test "OperationType: should convert integer to enum value" {
    try std.testing.expectEqual(State.fromValue(0), State.CLEAR);
    try std.testing.expectEqual(State.fromValue(1), State.FIELD_WRITE);
    try std.testing.expectEqual(State.fromValue(2), State.VALUE_WRITE);
    try std.testing.expectEqual(State.fromValue(3), State.CONTAINER_WRITE);
    try std.testing.expectEqual(State.fromValue(4), State.BOOL_WRITE);

    try std.testing.expectEqual(State.fromValue(5), State.FIELD_READ);
    try std.testing.expectEqual(State.fromValue(6), State.CONTAINER_READ);
    try std.testing.expectEqual(State.fromValue(7), State.VALUE_READ);
    try std.testing.expectEqual(State.fromValue(8), State.BOOL_READ);
}

test "OperationType: should convert from enum" {
    try std.testing.expect(State.CLEAR.toValue() == 0);
    try std.testing.expect(State.FIELD_WRITE.toValue() == 1);
    try std.testing.expect(State.VALUE_WRITE.toValue() == 2);
    try std.testing.expect(State.CONTAINER_WRITE.toValue() == 3);
    try std.testing.expect(State.BOOL_WRITE.toValue() == 4);

    try std.testing.expect(State.FIELD_READ.toValue() == 5);
    try std.testing.expect(State.CONTAINER_READ.toValue() == 6);
    try std.testing.expect(State.VALUE_READ.toValue() == 7);
    try std.testing.expect(State.BOOL_READ.toValue() == 8);
}

test "OperationType: should throw InvalidOperationTypeValue" {
    var result = State.fromValue(9);
    try std.testing.expectEqual(result, error.InvalidOperationTypeValue);
}
