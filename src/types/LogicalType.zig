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
