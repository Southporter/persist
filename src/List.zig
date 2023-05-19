const std = @import("std");

pub fn List(comptime T: type) type {
    return struct {
        const Self = @This();

        val: T,
        rest: ?*const Self,

        pub fn init(first: T) Self {
            return Self{
                .val = first,
                .rest = null,
            };
        }

        pub fn cons(self: *const Self, val: T) Self {
            return Self{
                .val = val,
                .rest = self,
            };
        }
    };
}
