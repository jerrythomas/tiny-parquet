const std = @import("std");
const PageType = @import("PageType.zig").PageType;

test "PageType: should convert integer to enum value" {
    try std.testing.expectEqual(PageType.fromValue(0), PageType.DATA_PAGE);
    try std.testing.expectEqual(PageType.fromValue(1), PageType.INDEX_PAGE);
    try std.testing.expectEqual(PageType.fromValue(2), PageType.DICTIONARY_PAGE);
    try std.testing.expectEqual(PageType.fromValue(3), PageType.DATA_PAGE_V2);
}

test "PageType: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(PageType.DATA_PAGE), 0);
    try std.testing.expectEqual(@intFromEnum(PageType.INDEX_PAGE), 1);
    try std.testing.expectEqual(@intFromEnum(PageType.DICTIONARY_PAGE), 2);
    try std.testing.expectEqual(@intFromEnum(PageType.DATA_PAGE_V2), 3);
}

test "PageType: should throw InvalidPageTypeValue" {
    const result = PageType.fromValue(4);
    try std.testing.expectEqual(result, error.InvalidPageTypeValue);
}

pub fn main() void {
    _ = @import("std").testing.runTests();
}
