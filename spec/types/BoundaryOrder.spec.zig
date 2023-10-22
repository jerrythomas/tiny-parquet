const std = @import("std");
const BoundaryOrder = @import("types").BoundaryOrder;

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

pub fn main() void {
    _ = try std.testing.runAllTests();
}
