const std = @import("std");
///
/// Enum to annotate whether lists of min/max elements inside ColumnIndex
/// are ordered and if so, in which direction.
///
pub const BoundaryOrder = enum(u8) {
    UNORDERED = 0,
    ASCENDING = 1,
    DESCENDING = 2,

    pub fn fromValue(value: u8) !BoundaryOrder {
        if (value > 2) {
            return error.InvalidBoundaryOrderValue;
        }
        return @as(BoundaryOrder, @enumFromInt(value));
    }

    pub fn toValue(self: BoundaryOrder) u8 {
        return @intFromEnum(self);
    }
};

test "BoundaryOrder: should convert integer to enum value" {
    try std.testing.expectEqual(BoundaryOrder.fromValue(0), BoundaryOrder.UNORDERED);
    try std.testing.expectEqual(BoundaryOrder.fromValue(1), BoundaryOrder.ASCENDING);
    try std.testing.expectEqual(BoundaryOrder.fromValue(2), BoundaryOrder.DESCENDING);
}

test "BoundaryOrder: should convert from enum" {
    try std.testing.expect(BoundaryOrder.UNORDERED.toValue() == 0);
    try std.testing.expect(BoundaryOrder.ASCENDING.toValue() == 1);
    try std.testing.expect(BoundaryOrder.DESCENDING.toValue() == 2);
}

test "BoundaryOrder: should throw InvalidBoundaryOrderValue" {
    const result = BoundaryOrder.fromValue(3);
    try std.testing.expectEqual(result, error.InvalidBoundaryOrderValue);
}
