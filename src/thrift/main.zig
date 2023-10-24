pub const types = @import("thrift.types");
pub const BinaryProtocolReader = @import("BinaryProtocolReader.zig").BinaryProtocolReader;
pub const BinaryProtocolWriter = @import("BinaryProtocolWriter.zig").BinaryProtocolWriter;

test {
    _ = types;

    _ = BinaryProtocolReader;
    _ = BinaryProtocolWriter;
}
