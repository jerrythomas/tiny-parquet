const std = @import("std");
const meta = @import("meta");

const AttributeWriter = meta.AttributeWriter;

test "AttributeWriter: Should write a number" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeNumber(i32, 10);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 10, 0, 0, 0 };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "AttributeWriter: Should write an optional number" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalNumber(i32, 11);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 1, 11, 0, 0, 0 };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "AttributeWriter: Should write an optional number as null" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalNumber(i32, null);

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{0};
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "AttributeWriter: Should write a string" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeString("Hello, Zig!");

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "AttributeWriter: Should write an optional string" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();

    _ = try writer.writeOptionalString("Hello, Zig!");

    var value = try writer.finalize();
    defer allocator.free(value);

    const expected = [_]u8{ 1, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}

test "AttributeWriter: Should write an optional null string" {
    var allocator = std.heap.page_allocator;
    var writer = try AttributeWriter.init(&allocator);
    defer writer.deinit();
    _ = try writer.writeOptionalString(null);

    var value = try writer.finalize();
    defer allocator.free(value);
    const expected = [_]u8{0};
    try std.testing.expect(std.mem.eql(u8, value, expected[0..]));
}
