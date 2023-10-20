const Millis = @import("Millis.zig").Millis;
const Micros = @import("Micros.zig").Micros;
const Nanos = @import("Nanos.zig").Nanos;

pub const TimeUnit = union(enum) {
    MILLIS: Millis,
    MICROS: Micros,
    NANOS: Nanos,

    pub fn fromValue(value: u8) !TimeUnit {
        switch (value) {
            1 => return .{ .MILLIS = Millis{} },
            2 => return .{ .MICROS = Micros{} },
            3 => return .{ .NANOS = Nanos{} },
            else => return error.InvalidTimeUnitValue,
        }
    }
    pub fn toValue(self: *TimeUnit) u8 {
        switch (self.*) {
            .MILLIS => return 1,
            .MICROS => return 2,
            .NANOS => return 3,
        }
    }
};
