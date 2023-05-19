const std = @import("std");
const List = @import("List.zig").List;
const ListManaged = @import("ListManaged.zig").ListManaged;
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    const IntList = List(i32);
    const iList = IntList.init(0);
    const iList2 = iList.cons(2);

    try testing.expect(iList2.val == 2);
    try testing.expect(iList2.rest.?.val == 0);
}

test "Managed List" {
    const IntList = ListManaged(i32);
    const iList = IntList.init(std.testing.allocator);
    defer iList.deinit();
    const iList2 = try iList.cons(1);
    defer iList2.deinit();
    try testing.expect(iList2.version == 1);
    try testing.expect(iList2.head == 0);
    try testing.expect(iList2.value() == 1);

    const iList3 = try iList.cons(2);
    defer iList3.deinit();
    try testing.expect(iList3.version == 1);
    try testing.expect(iList3.head == 0);
    try testing.expect(iList2.value() == 2);
}
