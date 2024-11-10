pub const PacketDefinition = @import("./packet.zig").PacketDefinition;

pub const DatabaseRequest = enum {
    DELETE,
    INSERT,
    FETCH,
};
pub const DatabasePacketContent = union {
    data: [2048]u8,
    hash: u32,
};
pub const DatabasePacket = struct {
    type: DatabaseRequest,
    owner: [64]u8,
    permissions: u8,
    data: DatabasePacketContent,
};

pub const ExecutionRequest = enum {
    SINGLE,
    DISTRIBUTED,
};
pub const ExecutionPacketConfig = struct {
    mem_size: u32,
    stack_size: u32,
    dimensions: [2]u8,
    code_size: u32,
};
pub const ExecutionPacket = struct {
    type: ExecutionRequest,
    config: ExecutionPacketConfig,
};

pub const ProtocolRequest = enum {
    DATABASE,
    EXECUTION,
};
pub const ProtocolPacketContent = union {
    database: DatabasePacket,
};
pub const ProtocolPacket = struct {
    version: [4]u8,
    type: ProtocolRequest,
    signed: bool,
    content: ProtocolPacketContent,
};
