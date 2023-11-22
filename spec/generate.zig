const std = @import("std");
const Endian = std.builtin.Endian;

pub fn bytesFromFloat(f: f64, endian: Endian) [8]u8 {
    var bytes: [8]u8 = undefined;
    std.mem.writeInt(i64, &bytes, @intFromFloat(f), endian);
    return bytes;
}

pub fn bytesFromNumber(comptime T: type, value: T, endian: Endian) []u8 {
    var bytes: [8]u8 = undefined;
    std.mem.writeInt(T, &bytes, value, endian);
    return bytes[0..@sizeOf(T)];
}

pub fn main() !void {
    var fs = std.fs.cwd();

    const file = try fs.createFile("spec/fixtures/mixed_data.bin", .{});
    // Open the file for appending and writing (creating if it doesn't exist).
    // const file = try fs.openFile("spec/fixtures/mixed_data.bin", .{
    //     .mode = .write_only,
    // });
    defer file.close();

    // Define the 8-byte array with the given values.
    const bytes: [8]u8 = [_]u8{ 192, 32, 64, 0, 0, 0, 0, 0 };

    // Write the bytes to the file.
    var result = try file.write(bytes[0..]);
    std.debug.print("Wrote {} bytes\n", .{result});
}
