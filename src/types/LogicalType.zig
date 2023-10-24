const std = @import("std");
const StringType = @import("StringType.zig").StringType;
const MapType = @import("MapType.zig").MapType;
const ListType = @import("ListType.zig").ListType;
const EnumType = @import("EnumType.zig").EnumType;
const DecimalType = @import("DecimalType.zig").DecimalType;
const DateType = @import("DateType.zig").DateType;
const TimeType = @import("TimeType.zig").TimeType;
const IntType = @import("IntType.zig").IntType;
const JsonType = @import("JsonType.zig").JsonType;
const BsonType = @import("BsonType.zig").BsonType;
const UUIDType = @import("UUIDType.zig").UUIDType;

pub const LogicalType = union(enum) {
    STRING: StringType,
    MAP: MapType,
    LIST: ListType,
    ENUM: EnumType,
    DECIMAL: DecimalType,
    DATE: DateType,
    TIME: TimeType,
    INTEGER: IntType,
    JSON: JsonType,
    BSON: BsonType,
    UUID: UUIDType,

    pub fn fromValue(value: u8) !LogicalType {
        switch (value) {
            1 => return .{ .STRING = StringType{} },
            2 => return .{ .MAP = MapType{} },
            3 => return .{ .LIST = ListType{} },
            4 => return .{ .ENUM = EnumType{} },
            5 => return .{ .DECIMAL = DecimalType{ .scale = 0, .precision = 0 } }, // Placeholder values
            6 => return .{ .DATE = DateType{} },
            7 => return .{ .TIME = TimeType{ .isAdjustedToUTC = false, .unit = .MILLISECONDS } }, // Placeholder values
            10 => return .{ .INTEGER = IntType{ .bitWidth = 8, .isSigned = false } }, // Placeholder values
            11 => return .{ .JSON = JsonType{} },
            12 => return .{ .BSON = BsonType{} },
            14 => return .{ .UUID = UUIDType{} },
            else => return error.InvalidLogicalType,
        }
    }

    pub fn toValue(self: *LogicalType) u8 {
        switch (self.*) {
            .STRING => return 1,
            .MAP => return 2,
            .LIST => return 3,
            .ENUM => return 4,
            .DECIMAL => return 5,
            .DATE => return 6,
            .TIME => return 7,
            .INTEGER => return 10,
            .JSON => return 11,
            .BSON => return 12,
            .UUID => return 14,
        }
    }
};

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

test "LogicalType: should handle invalid integer values" {
    const invalidValues = [_]u8{ 8, 9, 13, 15 };
    for (invalidValues) |value| {
        const result = LogicalType.fromValue(value);
        try std.testing.expectEqual(result, error.InvalidLogicalType);
    }
}
