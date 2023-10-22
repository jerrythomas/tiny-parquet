const std = @import("std");
const Statistics = @import("Statistics.zig").Statistics;

var default_allocator = std.heap.page_allocator;

test "Statistics fromBuffer and toBuffer" {
    var stats = Statistics{};
    var buffer = try default_allocator.alloc(u8, 4 * 10 + 16); // 4 binary fields of max length 10, and 2 i64 fields

    // Fill buffer with some test data
    std.mem.copy(u8, buffer[0..10], "max       ");
    std.mem.copy(u8, buffer[10..20], "min       ");
    std.mem.copy(u8, buffer[20..30], "max_value ");
    std.mem.copy(u8, buffer[30..40], "min_value ");
    std.mem.writeIntLittle(i64, buffer[40..48], 5);
    std.mem.writeIntLittle(i64, buffer[48..56], 10);

    try stats.fromBuffer(buffer);
    try std.testing.expectEqualStrings("max       ", stats.max.?);
    try std.testing.expectEqualStrings("min       ", stats.min.?);
    try std.testing.expectEqualStrings("max_value ", stats.max_value.?);
    try std.testing.expectEqualStrings("min_value ", stats.min_value.?);

    try std.testing.expectEqual(@as(i64, 5), stats.null_count.?);
    try std.testing.expectEqual(@as(i64, 10), stats.distinct_count.?);

    var new_buffer = try stats.toBuffer(null);
    defer default_allocator.free(new_buffer);

    try std.testing.expectEqualSlices(u8, buffer, new_buffer);
}

pub fn main() !void {
    _ = try std.testing.runAllTests();
    return null;
}
