const std = @import("std");
const LogicalType = @import("types").LogicalType;

test "LogicalType: should convert integer to enum value" {
    var logical_type: LogicalType = undefined;

    logical_type = try LogicalType.fromValue(1);
    try std.testing.expect(logical_type == LogicalType.STRING);

    logical_type = try LogicalType.fromValue(2);
    try std.testing.expect(logical_type == LogicalType.MAP);

    logical_type = try LogicalType.fromValue(3);
    try std.testing.expect(logical_type == LogicalType.LIST);

    logical_type = try LogicalType.fromValue(4);
    try std.testing.expect(logical_type == LogicalType.ENUM);

    logical_type = try LogicalType.fromValue(5);
    try std.testing.expect(logical_type == LogicalType.DECIMAL);

    logical_type = try LogicalType.fromValue(6);
    try std.testing.expect(logical_type == LogicalType.DATE);

    logical_type = try LogicalType.fromValue(7);
    try std.testing.expect(logical_type == LogicalType.TIME);

    logical_type = try LogicalType.fromValue(10);
    try std.testing.expect(logical_type == LogicalType.INTEGER);

    logical_type = try LogicalType.fromValue(11);
    try std.testing.expect(logical_type == LogicalType.JSON);

    logical_type = try LogicalType.fromValue(12);
    try std.testing.expect(logical_type == LogicalType.BSON);

    logical_type = try LogicalType.fromValue(14);
    try std.testing.expect(logical_type == LogicalType.UUID);
}

test "LogicalType: should handle invalid integer values" {
    const invalidValues = [_]u8{ 8, 9, 13, 15 };
    for (invalidValues) |value| {
        const result = LogicalType.fromValue(value);
        try std.testing.expectEqual(result, error.InvalidLogicalType);
    }
}

test "LogicalType: should convert enum value to integer" {
    var logical_type: LogicalType = undefined;

    logical_type = try LogicalType.fromValue(1);
    try std.testing.expectEqual(logical_type.toValue(), 1);

    logical_type = try LogicalType.fromValue(2);
    try std.testing.expectEqual(logical_type.toValue(), 2);

    logical_type = try LogicalType.fromValue(3);
    try std.testing.expectEqual(logical_type.toValue(), 3);

    logical_type = try LogicalType.fromValue(4);
    try std.testing.expectEqual(logical_type.toValue(), 4);

    logical_type = try LogicalType.fromValue(5);
    try std.testing.expectEqual(logical_type.toValue(), 5);

    logical_type = try LogicalType.fromValue(6);
    try std.testing.expectEqual(logical_type.toValue(), 6);

    logical_type = try LogicalType.fromValue(7);
    try std.testing.expectEqual(logical_type.toValue(), 7);

    logical_type = try LogicalType.fromValue(10);
    try std.testing.expectEqual(logical_type.toValue(), 10);

    logical_type = try LogicalType.fromValue(11);
    try std.testing.expectEqual(logical_type.toValue(), 11);

    logical_type = try LogicalType.fromValue(12);
    try std.testing.expectEqual(logical_type.toValue(), 12);

    logical_type = try LogicalType.fromValue(14);
    try std.testing.expectEqual(logical_type.toValue(), 14);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
