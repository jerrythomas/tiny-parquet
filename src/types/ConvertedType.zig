pub const ConvertedType = enum(u8) {
    UTF8 = 0,
    MAP = 1,
    MAP_KEY_VALUE = 2,
    LIST = 3,
    ENUM = 4,
    DECIMAL = 5,
    DATE = 6,
    TIME_MILLIS = 7,
    TIME_MICROS = 8,
    TIMESTAMP_MILLIS = 9,
    TIMESTAMP_MICROS = 10,
    UINT_8 = 11,
    UINT_16 = 12,
    UINT_32 = 13,
    UINT_64 = 14,
    INT_8 = 15,
    INT_16 = 16,
    INT_32 = 17,
    INT_64 = 18,
    JSON = 19,
    BSON = 20,
    INTERVAL = 21,

    pub fn fromValue(value: u8) !ConvertedType {
        if (value > 21) {
            return error.InvalidConvertedTypeValue;
        }
        return @as(ConvertedType, @enumFromInt(value));
    }

    pub fn toValue(self: ConvertedType) u8 {
        return @intFromEnum(self);
    }
};
