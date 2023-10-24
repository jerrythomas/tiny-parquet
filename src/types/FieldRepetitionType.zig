const std = @import("std");
/// Representation of Schemas
pub const FieldRepetitionType = enum(u8) {
    REQUIRED = 0, // This field is required (can not be null) and each record has exactly 1 value.
    OPTIONAL = 1, // The field is optional (can be null) and each record has 0 or 1 values.
    REPEATED = 2, // The field is repeated and can contain 0 or more values.

    pub fn fromValue(value: u8) !FieldRepetitionType {
        if (value > 2) {
            return error.InvalidFieldRepetitionTypeValue;
        }
        return @as(FieldRepetitionType, @enumFromInt(value));
    }

    pub fn toValue(self: FieldRepetitionType) u8 {
        return @intFromEnum(self);
    }
};

test "FieldRepetitionType: should convert integer to enum value" {
    try std.testing.expectEqual(FieldRepetitionType.fromValue(0), FieldRepetitionType.REQUIRED);
    try std.testing.expectEqual(FieldRepetitionType.fromValue(1), FieldRepetitionType.OPTIONAL);
    try std.testing.expectEqual(FieldRepetitionType.fromValue(2), FieldRepetitionType.REPEATED);
}

test "FieldRepetitionType: should convert from enum" {
    try std.testing.expect(FieldRepetitionType.REQUIRED.toValue() == 0);
    try std.testing.expect(FieldRepetitionType.OPTIONAL.toValue() == 1);
    try std.testing.expect(FieldRepetitionType.REPEATED.toValue() == 2);
}

test "FieldRepetitionType: should throw InvalidFieldRepetitionTypeValue" {
    const result = FieldRepetitionType.fromValue(3);
    try std.testing.expectEqual(result, error.InvalidFieldRepetitionTypeValue);
}
