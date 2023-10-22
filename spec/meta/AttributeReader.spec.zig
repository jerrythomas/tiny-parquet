const std = @import("std");
const meta = @import("meta");

const AttributeReader = meta.AttributeReader;

test "AttributeReader: should read a number" {
    const buffer = [_]u8{ 10, 0, 0, 0 };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readNumber(i32);
    try std.testing.expectEqual(value, 10);
    try std.testing.expectEqual(reader.offset, 4);
}

test "AttributeReader: should read an optional number" {
    const buffer = [_]u8{ 1, 10, 0, 0, 0 };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(value.?, 10);
    try std.testing.expectEqual(reader.offset, 5);
}

test "AttributeReader: should read an optional null number" {
    const buffer = [_]u8{ 0, 10, 0, 0, 0 };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(value, null);
    try std.testing.expectEqual(reader.offset, 1);
}

test "AttributeReader: should read a string" {
    const buffer = [_]u8{ 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readString();

    try std.testing.expectEqualStrings(value, "Hello, Zig!");
    try std.testing.expectEqual(reader.offset, 4 + 11);
}

test "AttributeReader: should read an optional string" {
    const buffer = [_]u8{ 1, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readOptionalString();

    try std.testing.expectEqualStrings(value.?, "Hello, Zig!");
    try std.testing.expectEqual(reader.offset, 1 + 4 + 11);
}

test "AttributeReader: should read an optional null string" {
    const buffer = [_]u8{ 0, 11, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', ',', ' ', 'Z', 'i', 'g', '!' };
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readOptionalString();

    try std.testing.expectEqual(value, null);
    try std.testing.expectEqual(reader.offset, 1);
}

test "AttributeReader: should read a boolean" {
    const buffer = [_]u8{1};
    var reader = AttributeReader.init(&buffer);
    var value = try reader.readBoolean();

    try std.testing.expect(value);
    try std.testing.expectEqual(reader.offset, 1);
}

test "AttributeReader: should read multiple values" {
    const buffer = [_]u8{ 0, 5, 0, 0, 0, 'H', 'e', 'l', 'l', 'o', 0, 5, 0, 0, 0, 4, 0, 0, 0, 'Z', 'i', 'g', '!' };
    var reader = AttributeReader.init(&buffer);
    var stringValue = try reader.readOptionalString();
    try std.testing.expectEqual(stringValue, null);
    stringValue = try reader.readString();
    try std.testing.expectEqualStrings(stringValue.?, "Hello");
    var numberValue = try reader.readOptionalNumber(i32);
    try std.testing.expectEqual(numberValue, null);
    numberValue = try reader.readNumber(i32);
    try std.testing.expectEqual(numberValue.?, 5);
    stringValue = try reader.readString();
    try std.testing.expectEqualStrings(stringValue.?, "Zig!");
    try std.testing.expectEqual(reader.offset, buffer.len);
}
