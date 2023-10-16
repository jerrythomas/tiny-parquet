/// Representation of Schemas
pub const FieldRepetitionType = enum(u8) {
    REQUIRED = 0, // This field is required (can not be null) and each record has exactly 1 value.
    OPTIONAL = 1, // The field is optional (can be null) and each record has 0 or 1 values.
    REPEATED = 2, // The field is repeated and can contain 0 or more values.

    pub fn fromValue(value: u8) !FieldRepetitionType {
        if (value > 2) {
            return error.InvalidFieldRepetitionTypeValue;
        }
        return @as(FieldRepetitionType, @enumFromInt(value));
    }
};
