const TimeUnit = @import("TimeUnit.zig").TimeUnit;

pub const TimeType = struct {
    isAdjustedToUTC: bool,
    unit: TimeUnit,
};
