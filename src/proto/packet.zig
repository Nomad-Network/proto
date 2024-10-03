const std = @import("std");

pub fn PacketDefinition(comptime T: type, allocator: std.mem.Allocator) type {
    return struct {
        const size = @sizeOf(T);

        pub fn read(reader: std.io.AnyReader) !*T {
            const buffer = try reader.readAllAlloc(allocator, size);
            return @ptrCast(buffer.ptr);
        }

        pub fn getSize() u64 {
            return @as(u64, size);
        }

        pub fn serialize(instance: *const T) *[@sizeOf(T)]u8 {
            return @ptrCast(@constCast(instance));
        }

        pub fn deserialize(buffer: *[@sizeOf(T)]u8) *T {
            return @alignCast(@ptrCast(buffer));
        }
    };
}
