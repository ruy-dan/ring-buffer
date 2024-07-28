const std = @import("std");
const expectEqual = std.testing.expectEqual;
const expectError = std.testing.expectError;
const RingBuffer = @import("ring_buffer.zig").RingBuffer;

test "basic, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    var output: u8 = undefined;
    try buffer.read(&output);
    try expectEqual(1, output);
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
    var output: u8 = undefined;
    try expectError(error.BufferEmpty, buffer.read(&output));
}

test "multiple writes and reads, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);

    var output: u8 = undefined;
    try expectError(error.BufferFull, buffer.write(5));

    try buffer.read(&output);
    try expectEqual(1, output);

    try buffer.write(5);

    try buffer.read(&output);
    try expectEqual(2, output);

    try buffer.read(&output);
    try expectEqual(3, output);

    try buffer.read(&output);
    try expectEqual(4, output);

    try buffer.read(&output);
    try expectEqual(5, output);

    try expectError(error.BufferEmpty, buffer.read(&output));
}

test "multiple buffer buffer operations with unbounded indices" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();

    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);
    try expectError(error.BufferFull, buffer.write(5));

    var output: u8 = undefined;
    try buffer.read(&output);
    try expectEqual(1, output);
    try buffer.read(&output);
    try expectEqual(2, output);
    try buffer.read(&output);
    try expectEqual(3, output);
    try buffer.read(&output);
    try expectEqual(4, output);
    try expectError(error.BufferEmpty, buffer.read(&output));

    try buffer.write(6);
    try buffer.write(7);
    try buffer.write(8);
    buffer.print(); // Expected output: 6, 7, 8,
}

test "basic, []const u8" {
    var buffer = try RingBuffer([]const u8, .{ .capacity = 4 }).init();
    try buffer.write("hello");
    var output: []const u8 = undefined;
    try buffer.read(&output);
    try expectEqual("hello", output);
}

test "basic overwrite, []const u8" {
    var buffer = try RingBuffer([]const u8, .{ .capacity = 2 }).init();
    try buffer.write("hello");
    try buffer.write("circular");

    var output: []const u8 = undefined;
    try buffer.read(&output);
    try expectEqual("hello", output);

    try buffer.read(&output);
    try expectEqual("circular", output);

    try buffer.write("world");

    try buffer.read(&output);
    try expectEqual("world", output);
}

test "boundary conditions, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    try buffer.write(4);

    var output: u8 = undefined;
    try buffer.read(&output);
    try expectEqual(1, output);

    try buffer.write(5);
    try expectError(error.BufferFull, buffer.write(6));

    try buffer.read(&output);
    try expectEqual(2, output);
    try buffer.read(&output);
    try expectEqual(3, output);
    try buffer.read(&output);
    try expectEqual(4, output);
    try buffer.read(&output);
    try expectEqual(5, output);

    try expectError(error.BufferEmpty, buffer.read(&output));
}

test "print, u8" {
    var buffer = try RingBuffer(u8, .{ .capacity = 4 }).init();
    try buffer.write(1);
    try buffer.write(2);
    try buffer.write(3);
    buffer.print(); // expected: 1, 2, 3,

    var output: u8 = undefined;
    try buffer.read(&output);
    try expectEqual(1, output);

    try buffer.write(4);
    buffer.print(); // expected: 2, 3, 4,
}
