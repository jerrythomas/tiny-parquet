const std = @import("std");
const TimeUnit = @import("types").TimeUnit;

test "TimeUnit: should convert integer to enum value" {
    var unit: TimeUnit = undefined;
    unit = try TimeUnit.fromValue(1);
    try std.testing.expect(unit == TimeUnit.MILLIS);

    unit = try TimeUnit.fromValue(2);
    try std.testing.expect(unit == TimeUnit.MICROS);

    unit = try TimeUnit.fromValue(3);
    try std.testing.expect(unit == TimeUnit.NANOS);
}

test "TimeUnit: should handle invalid integer values" {
    const result = TimeUnit.fromValue(4);
    try std.testing.expectEqual(result, error.InvalidTimeUnitValue);
}

test "TimeUnit: should convert enum value to integer" {
    var unit: TimeUnit = undefined;

    unit = try TimeUnit.fromValue(1);
    try std.testing.expectEqual(unit.toValue(), 1);

    unit = try TimeUnit.fromValue(2);
    try std.testing.expectEqual(unit.toValue(), 2);

    unit = try TimeUnit.fromValue(3);
    try std.testing.expectEqual(unit.toValue(), 3);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
