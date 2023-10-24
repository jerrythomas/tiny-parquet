pub fn zigzag(comptime T: type, n: T) T {
    return (n >> 1) ^ @as(T, @intCast(@as(isize, n) & 1));
}

pub fn main() void {
    const a: u8 = 5;
    const b: u16 = 10;
    const c: u32 = 15;

    @import("std").debug.print("{b}\n", .{zigzag(u8, a)});
    @import("std").debug.print("{x}\n", .{zigzag(u16, b)});
    @import("std").debug.print("{x}\n", .{zigzag(u32, c)});
}
