const std = @import("std");
pub const PageType = enum(u8) {
    DATA_PAGE = 0,
    INDEX_PAGE = 1,
    DICTIONARY_PAGE = 2,
    DATA_PAGE_V2 = 3,

    pub fn fromValue(value: u8) !PageType {
        if (value > 3) {
            return error.InvalidPageTypeValue;
        }
        return @as(PageType, @enumFromInt(value));
    }

    pub fn toValue(self: PageType) u8 {
        return @intFromEnum(self);
    }
};

test "PageType: should convert integer to enum value" {
    try std.testing.expectEqual(PageType.fromValue(0), PageType.DATA_PAGE);
    try std.testing.expectEqual(PageType.fromValue(1), PageType.INDEX_PAGE);
    try std.testing.expectEqual(PageType.fromValue(2), PageType.DICTIONARY_PAGE);
    try std.testing.expectEqual(PageType.fromValue(3), PageType.DATA_PAGE_V2);
}

test "PageType: should convert from enum" {
    try std.testing.expect(PageType.DATA_PAGE.toValue() == 0);
    try std.testing.expect(PageType.INDEX_PAGE.toValue() == 1);
    try std.testing.expect(PageType.DICTIONARY_PAGE.toValue() == 2);
    try std.testing.expect(PageType.DATA_PAGE_V2.toValue() == 3);
}

test "PageType: should throw InvalidPageTypeValue" {
    const result = PageType.fromValue(4);
    try std.testing.expectEqual(result, error.InvalidPageTypeValue);
}
