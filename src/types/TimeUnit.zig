const std = @import("std");

const Milliseconds = @import("Milliseconds.zig").Milliseconds;
const Microseconds = @import("Microseconds.zig").Microseconds;
const Nanoseconds = @import("Nanoseconds.zig").Nanoseconds;

pub const TimeUnit = union(enum) {
    MILLISECONDS: Milliseconds,
    MICROSECONDS: Microseconds,
    NANOSECONDS: Nanoseconds,

    pub fn fromValue(value: u8) !TimeUnit {
        switch (value) {
            1 => return .{ .MILLISECONDS = Milliseconds{} },
            2 => return .{ .MICROSECONDS = Microseconds{} },
            3 => return .{ .NANOSECONDS = Nanoseconds{} },
            else => return error.InvalidTimeUnitValue,
        }
    }
    pub fn toValue(self: *TimeUnit) u8 {
        switch (self.*) {
            .MILLISECONDS => return 1,
            .MICROSECONDS => return 2,
            .NANOSECONDS => return 3,
        }
    }
};

test "TimeUnit: should convert integer to enum value" {
    var unit: TimeUnit = undefined;
    unit = try TimeUnit.fromValue(1);
    try std.testing.expect(unit == TimeUnit.MILLISECONDS);

    unit = try TimeUnit.fromValue(2);
    try std.testing.expect(unit == TimeUnit.MICROSECONDS);

    unit = try TimeUnit.fromValue(3);
    try std.testing.expect(unit == TimeUnit.NANOSECONDS);
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
