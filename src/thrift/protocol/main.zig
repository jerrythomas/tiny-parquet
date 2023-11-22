pub const BinaryProtocolReader = @import("BinaryProtocolReader.zig").BinaryProtocolReader;
pub const CompactProtocolReader = @import("CompactProtocolReader.zig").CompactProtocolReader;
pub const ProtocolReader = @import("extensible.zig").ProtocolReader;

test {
    _ = BinaryProtocolReader;
    _ = CompactProtocolReader;
    _ = ProtocolReader;
}
