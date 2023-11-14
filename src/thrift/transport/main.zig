const std = @import("std");
const Transport = @import("Transport.zig").Transport;
const FileReader = @import("File.zig").FileReader;

test "Transport: read/write" {
    var t = FileReader{ .allocator = std.testing.allocator };
    var transport = Transport.from(&t, FileReader);

    try transport.open("spec/fixtures/example.txt");
    // defer transport.close();
    try std.testing.expectEqual(transport.total_size, 10);
    try transport.read(0, 10);

    var data = try transport.readBytes(5);
    std.debug.print("data: {s}\n", .{data});
    try std.testing.expectEqualStrings(data, "hello");
    try std.testing.expectEqual(transport.read_start, 5);
    try std.testing.expectEqual(transport.read_end, 10);

    var space = try transport.readNumber(i8);
    try std.testing.expectEqual(space, 32);
    try std.testing.expectEqual(transport.read_start, 6);
    try std.testing.expectEqual(transport.read_end, 10);

    data = try transport.readBytes(4);
    try std.testing.expectEqualStrings(data, "zig!");
    try std.testing.expectEqual(transport.read_start, 10);
    try std.testing.expectEqual(transport.read_end, 10);

    transport.close();
}
