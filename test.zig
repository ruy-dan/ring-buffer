const std = @import("std");
const expectEqual = std.testing.expectEqual;
const expectError = std.testing.expectError;
const RingBuffer = @import("ring_buffer.zig").RingBuffer;

test "basic, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try expectEqual(1, try buffer.read());
}

test "write fails when full, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);
    try expectError(error.BufferFull, buffer.write(5));
}

test "read fails when empty, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try expectError(error.BufferEmpty, buffer.read());
}

test "multiple writes and reads, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);

    try expectError(error.BufferFull, buffer.write(5));

    try expectEqual(1, try buffer.read());

    try buffer.write(5);

    try expectEqual(2, try buffer.read());
    try expectEqual(3, try buffer.read());
    try expectEqual(4, try buffer.read());
    try expectEqual(5, try buffer.read());

    try expectError(error.BufferEmpty, buffer.read());
}

test "multiple buffer buffer operations with unbounded indices" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();

    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);
    try expectError(error.BufferFull, buffer.write(5));

    try expectEqual(1, try buffer.read());
    try expectEqual(2, try buffer.read());
    try expectEqual(3, try buffer.read());
    try expectEqual(4, try buffer.read());
    try expectError(error.BufferEmpty, buffer.read());

    try buffer.write(6);
    try buffer.write(7);
    try buffer.write(8);
}

test "basic, []const u8" {
    var buffer = try RingBuffer([]const u8, .{ .capacity = 4 }).init();
    try buffer.write("hello");
    try expectEqual("hello", try buffer.read());
}

test "basic overwrite, []const u8" {
    var buffer = try RingBuffer([]const u8, .{ .capacity = 2 }).init();
    try buffer.write("hello");
    try buffer.write("circular");

    try expectEqual("hello", try buffer.read());
    try expectEqual("circular", try buffer.read());

    try buffer.write("world");
    try expectEqual("world", try buffer.read());
}

test "boundary conditions, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);

    try expectEqual(1, try buffer.read());

    try buffer.write(5);
    try expectError(error.BufferFull, buffer.write(6));

    try expectEqual(2, try buffer.read());
    try expectEqual(3, try buffer.read());
    try expectEqual(4, try buffer.read());
    try expectEqual(5, try buffer.read());

    try expectError(error.BufferEmpty, buffer.read());
}
