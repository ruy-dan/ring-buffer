const std = @import("std");

const Opts = struct {
    capacity: usize = 1024,
};

pub fn RingBuffer(comptime T: type, opts: Opts) type {
    return struct {
        buffer: [opts.capacity]T,
        r: usize,
        w: usize,

        const Self = @This();

        pub fn init() !Self {
            if (!isPowerOfTwo(opts.capacity)) return error.InvalidCapacity;

            return Self{
                .buffer = undefined,
                .r = 0,
                .w = 0,
            };
        }

        fn isPowerOfTwo(value: usize) bool {
            return value != 0 and (value & (value - 1)) == 0;
        }

        fn mask(self: Self, index: usize) usize {
            return index & (self.buffer.len - 1);
        }

        pub fn isEmpty(self: Self) bool {
            return self.w == self.r;
        }

        pub fn isFull(self: Self) bool {
            return self.size() == self.buffer.len;
        }

        pub fn size(self: Self) usize {
            return self.w - self.r;
        }

        pub fn write(self: *Self, item: T) !void {
            if (self.isFull()) return error.BufferFull;
            self.buffer[self.mask(self.w)] = item;
            self.w += 1;
        }

        pub fn read(self: *Self, output: *T) !void {
            if (self.isEmpty()) return error.BufferEmpty;
            output.* = self.buffer[self.mask(self.r)];
            self.r += 1;
        }

        pub fn clear(self: *Self) void {
            self.r = 0;
            self.w = 0;
        }

        pub fn print(self: Self) void {
            for (0..self.size()) |i| {
                std.debug.print("{any}, ", .{self.buffer[self.mask(i)]});
            }
            std.debug.print("\n", .{});
        }
    };
}
