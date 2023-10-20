pub const Micros = struct {
    pub fn toSeconds(micros: u64) f64 {
        return @as(f64, micros / 1000000.0);
    }
};
