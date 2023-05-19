const std = @import("std");

fn Node(comptime T: type) type {
    return struct {
        const Self = @This();
        val: T,
        next: usize,
    };
}

pub fn ListManaged(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        nodes: std.MultiArrayList(Node(T)),
        head: usize,
        version: usize = 0,

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .nodes = .{},
                .head = std.math.maxInt(u32),
            };
        }

        pub fn deinit(self: *const Self) void {
            var nodes = self.nodes;
            nodes.deinit(self.allocator);
        }

        pub fn cons(self: *const Self, val: T) !Self {
            var oldHead = self.head;
            var nodes = self.nodes;
            var newHead = try nodes.addOne(self.allocator);
            nodes.set(newHead, .{ .val = val, .next = oldHead });

            return Self{
                .allocator = self.allocator,
                .nodes = nodes,
                .head = newHead,
                .version = self.version + 1,
            };
        }
        pub fn value(self: *const Self) T {
            return self.nodes.items(.val)[self.head];
        }
    };
}
