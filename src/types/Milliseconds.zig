pub const Milliseconds = struct {
    pub fn toSeconds(value: u32) f32 {
        return value / 1000.0;
    }
};
