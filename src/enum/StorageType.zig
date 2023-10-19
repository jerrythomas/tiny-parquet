pub const StorageType = enum(u8) {
    DISK = 0,
    S3 = 1,

    pub fn fromValue(value: u8) !StorageType {
        if (value > 1) {
            return error.InvalidStorageTypeValue;
        }
        return @as(StorageType, @enumFromInt(value));
    }
};
