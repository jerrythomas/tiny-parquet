const std = @import("std");

var default_allocator = std.heap.page_allocator;

pub const AttributeWriter = struct {
    buffer: std.ArrayList(u8),
    allocator: *std.mem.Allocator = &default_allocator,

    pub fn init(allocator: ?*std.mem.Allocator) !AttributeWriter {
        var derived_allocator = allocator orelse &default_allocator;

        return AttributeWriter{
            .allocator = derived_allocator,
            .buffer = std.ArrayList(u8).init(derived_allocator.*),
        };
    }

    pub fn deinit(self: *AttributeWriter) void {
        self.buffer.deinit();
    }

    pub fn writeIndicator(self: *AttributeWriter, isPresent: bool) !void {
        _ = try self.buffer.append(@as(u8, if (isPresent) 1 else 0));
    }

    pub fn writeNumber(self: *AttributeWriter, comptime T: type, value: T) !void {
        _ = try self.buffer.appendSlice(std.mem.asBytes(&value));
    }
    pub fn writeOptionalNumber(self: *AttributeWriter, comptime T: type, value: ?T) !void {
        _ = try self.writeIndicator(value != null);

        if (value != null) {
            _ = try self.writeNumber(T, value.?);
        }
    }

    pub fn writeString(self: *AttributeWriter, value: []const u8) !void {
        _ = try self.writeNumber(u32, @as(u32, @intCast(value.len)));
        _ = try self.buffer.appendSlice(value);
    }

    pub fn writeOptionalString(self: *AttributeWriter, value: ?[]const u8) !void {
        _ = try self.writeIndicator(value != null);

        if (value != null) {
            _ = try self.writeString(value.?);
        }
    }

    pub fn finalize(self: *AttributeWriter) ![]const u8 {
        return try self.buffer.toOwnedSlice();
    }
};
