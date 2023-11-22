pub const MessageType = @import("MessageType.zig").MessageType;
pub const ThriftType = @import("ThriftType.zig").ThriftType;
pub const State = @import("State.zig").State;
pub const CompactType = @import("CompactType.zig").CompactType;

pub const VERSION_MASK: u32 = 0xffff0000;
pub const VERSION_1: u32 = 0x80010000;
pub const TYPE_MASK: u8 = 255;

pub const FieldHeader = struct {
    name: ?[]const u8 = undefined,
    field_type: ThriftType = undefined,
    id: i16 = 0,
};

pub const MapHeader = struct {
    key_type: ThriftType = undefined,
    value_type: ThriftType = undefined,
    size: i32 = 0,
};

pub const ListHeader = struct {
    element_type: ThriftType = undefined,
    size: i32 = 0,
};

pub const MessageHeader = struct {
    version: ?u32 = null,
    type: MessageType = undefined,
    name: ?[]const u8 = null,
    sequence_id: i32 = 0,
};

pub const Structure = struct {
    state: State = undefined,
    last_fid: i16 = 0,
};

test {
    _ = CompactType;
    _ = MessageType;
    _ = ThriftType;
    _ = State;
}
