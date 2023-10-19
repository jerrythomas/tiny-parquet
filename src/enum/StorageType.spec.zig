const std = @import("std");
const StorageType = @import("enum").StorageType;

test "StorageType: should convert integer to enum value" {
    try std.testing.expectEqual(StorageType.fromValue(0), StorageType.DISK);
    try std.testing.expectEqual(StorageType.fromValue(1), StorageType.S3);
}

test "StorageType: should convert from enum" {
    try std.testing.expectEqual(@intFromEnum(StorageType.DISK), 0);
    try std.testing.expectEqual(@intFromEnum(StorageType.S3), 1);
}

test "StorageType: should throw InvalidStorageTypeValue" {
    const result = StorageType.fromValue(2);
    try std.testing.expectEqual(result, error.InvalidStorageTypeValue);
}

pub fn main() void {
    _ = try std.testing.runAllTests();
}
