pub const MessageType = @import("MessageType.zig").MessageType;
pub const Types = @import("Types.zig").Types;
pub const State = @import("State.zig").State;
pub const CompactType = @import("CompactType.zig").CompactType;

pub const VERSION_MASK: u32 = 0xffff0000;
pub const VERSION_1: u32 = 0x80010000;
pub const TYPE_MASK: u8 = 255;

pub const FieldHeader = struct {
    name: ?[]const u8 = undefined,
    field_type: Types = undefined,
    id: i16 = 0,
};

pub const MapHeader = struct {
    key_type: Types = undefined,
    value_type: Types = undefined,
    size: i32 = 0,
};

pub const ListHeader = struct {
    element_type: Types = undefined,
    size: i32 = 0,
};

pub const MessageHeader = struct {
    version: ?u32 = null,
    type: MessageType = undefined,
    name: ?[]const u8 = null,
    sequence_id: i32 = 0,
};

test {
    _ = CompactType;
    _ = MessageType;
    _ = Types;
    _ = State;
}
