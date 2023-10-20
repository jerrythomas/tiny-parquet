pub const Nanoseconds = struct {
    pub fn toSeconds(value: u64) f64 {
        return value / 1000000000.0;
    }
};
