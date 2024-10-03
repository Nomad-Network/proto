//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const nomad = @import("nomad");
const nomad_proto = @import("nomad-proto");

const DBPkt = nomad_proto.PacketDefinition(nomad_proto.DatabasePacket, std.heap.page_allocator);

pub fn main() !void {
    std.log.info("size: {any}", .{DBPkt.getSize()});
    const pkt = &nomad_proto.DatabasePacket{
        .type = .FETCH,
        .owner = 0,
        .permissions = 0,
        .data = .{
            .hash = 0,
        },
    };
    const data = DBPkt.serialize(pkt);
    std.log.info("data: {any}", .{data});
    const inst = DBPkt.deserialize(data);
    std.log.info("pkt: {any}", .{inst});
    var db = try nomad.Database.init(std.heap.page_allocator, "test.nd");
    try db.print();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const global = struct {
        fn testOne(input: []const u8) anyerror!void {
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(global.testOne, .{});
}