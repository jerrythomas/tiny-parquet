pub const Nanos = struct {
    pub fn toSeconds(nanos: u64) f64 {
        return nanos / 1000000000.0;
    }
};
