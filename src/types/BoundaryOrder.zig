const std = @import("std");
///
/// Enum to annotate whether lists of min/max elements inside ColumnIndex
/// are ordered and if so, in which direction.
///
pub const BoundaryOrder = enum(u8) {
    UNORDERED = 0,
    ASCENDING = 1,
    DESCENDING = 2,

    pub fn fromValue(value: u8) !BoundaryOrder {
        if (value > 2) {
            return error.InvalidBoundaryOrderValue;
        }
        return @as(BoundaryOrder, @enumFromInt(value));
    }

    pub fn toValue(self: BoundaryOrder) u8 {
        return @intFromEnum(self);
    }
};
