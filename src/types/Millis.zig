pub const Millis = struct {
    pub fn toSeconds(millis: u32) f32 {
        return millis / 1000.0;
    }
};
