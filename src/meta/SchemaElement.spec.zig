const std = @import("std");
const meta = @import("meta");

test "SchemaElement: should convert from buffer for nulls" {
    var allocator = std.heap.page_allocator;
    var writer = try meta.AttributeWriter.init(&allocator);
    defer writer.deinit();

    try writer.writeOptionalNumber(u8, null);
    try writer.writeOptionalNumber(i32, null);
    try writer.writeOptionalNumber(i32, null);
    try writer.writeString("schema");
    try writer.writeOptionalNumber(i32, null);
    try writer.writeOptionalNumber(u8, null);
    try writer.writeOptionalNumber(i32, null);
    try writer.writeOptionalNumber(i32, null);
    try writer.writeOptionalNumber(i32, null);
    try writer.writeOptionalNumber(u8, null);

    var buffer = try writer.finalize();
    defer allocator.free(buffer);

    var schema = try meta.SchemaElement.init(
        &allocator,
    );
    defer schema.deinit();

    var offset = try schema.fromBuffer(buffer);

    try std.testing.expectEqual(schema.type, null);
    try std.testing.expectEqual(schema.type_length, null);
    try std.testing.expectEqual(schema.repetition_type, null);
    try std.testing.expectEqualStrings(schema.name, "schema");
    try std.testing.expectEqual(schema.num_children, null);
    try std.testing.expectEqual(schema.converted_type, null);
    try std.testing.expectEqual(schema.scale, null);
    try std.testing.expectEqual(schema.precision, null);
    try std.testing.expectEqual(schema.field_id, null);
    try std.testing.expectEqual(schema.logicalType, null);

    try std.testing.expectEqual(offset, buffer.len);
    try std.testing.expectEqual(schema.children, null);
}
