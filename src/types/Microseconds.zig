pub const Microsseconds = struct {
    pub fn toSeconds(value: u64) f64 {
        return @as(f64, value / 1000000.0);
    }
};
