const std = @import("std");
const FieldRepetitionType = @import("FieldRepetitionType.zig").FieldRepetitionType;

test "FieldRepetitionType: should convert integer to enum value" {
    try std.testing.expectEqual(FieldRepetitionType.fromValue(0), FieldRepetitionType.REQUIRED);
    try std.testing.expectEqual(FieldRepetitionType.fromValue(1), FieldRepetitionType.OPTIONAL);
    try std.testing.expectEqual(FieldRepetitionType.fromValue(2), FieldRepetitionType.REPEATED);
}

test "FieldRepetitionType: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(FieldRepetitionType.REQUIRED), 0);
    try std.testing.expectEqual(@intFromEnum(FieldRepetitionType.OPTIONAL), 1);
    try std.testing.expectEqual(@intFromEnum(FieldRepetitionType.REPEATED), 2);
}

test "FieldRepetitionType: should throw InvalidFieldRepetitionTypeValue" {
    const result = FieldRepetitionType.fromValue(3);
    try std.testing.expectEqual(result, error.InvalidFieldRepetitionTypeValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
