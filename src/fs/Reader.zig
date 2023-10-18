pub const Reader = struct {
    pub fn read(self: *Self, bytes: *u8, offset: i64) usize;
};
