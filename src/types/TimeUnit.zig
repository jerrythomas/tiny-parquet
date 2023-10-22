const Milliseconds = @import("Milliseconds.zig").Milliseconds;
const Microseconds = @import("Microseconds.zig").Microseconds;
const Nanoseconds = @import("Nanoseconds.zig").Nanoseconds;

pub const TimeUnit = union(enum) {
    MILLISECONDS: Milliseconds,
    MICROSECONDS: Microseconds,
    NANOSECONDS: Nanoseconds,

    pub fn fromValue(value: u8) !TimeUnit {
        switch (value) {
            1 => return .{ .MILLISECONDS = Milliseconds{} },
            2 => return .{ .MICROSECONDS = Microseconds{} },
            3 => return .{ .NANOSECONDS = Nanoseconds{} },
            else => return error.InvalidTimeUnitValue,
        }
    }
    pub fn toValue(self: *TimeUnit) u8 {
        switch (self.*) {
            .MILLISECONDS => return 1,
            .MICROSECONDS => return 2,
            .NANOSECONDS => return 3,
        }
    }
};
