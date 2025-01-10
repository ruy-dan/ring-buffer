# ring-buffer

A Ring Buffer implementation with a fixed-size buffer.

## Usage

```zig
const RingBuffer = @import("ring-buffer").RingBuffer;

var buffer = try RingBuffer([]const u8, .{ .capacity = 2 }).init();
try buffer.write("hello");
try buffer.write("circular");

_ = try buffer.read(); // hello
_ = try buffer.read(); // circular

try buffer.write("world");
_ = try buffer.read(); // world
```

## Install
```sh
zig fetch --save https://github.com/ruy-dan/ring-buffer/archive/refs/heads/main.tar.gz
```

build.zig.zon
```zig
.dependencies = .{
    .ring_buffer = .{
        .url = "https://github.com/ruy-dan/ring-buffer/archive/refs/heads/main.tar.gz",
        // .hash
    }
}
```

build.zig
```zig
const ring_buffer = b.dependency("ring_buffer", .{
    .target = target,
    .optimize = optimize,
});
exe.addModule("ring-buffer", ring_buffer.module("ring-buffer"));
```

```sh
zig build run
```

## API

```zig
pub fn RingBuffer(comptime T: type, opts: Opts) !type
```
Creates a new RingBuffer with a fixed-size buffer.
The capacity can be set through opts. Otherwise, the default capacity is set to 1024.
Returns an error if the capacity is not a power of two.

`const Opts = struct { capacity: usize = 1024 };`


## Test
```zig
zig test test.zig
```

### Methods

#### `isEmpty() bool`

Returns `true` if the ring buffer is empty, `false` otherwise.

#### `isFull() bool`

Returns `true` if the ring buffer is full, `false` otherwise.

#### `size() usize`

Returns the number of elements in the ring buffer.

#### `write(self: *Self, item: T) !void`

Writes an item to the ring buffer. Returns an error if the buffer is full.

#### `read(self: *Self) !T`

Reads an item from the ring buffer. Returns an error if the buffer is empty.

#### `clear(self: *Self) void`

Clears the ring buffer.

#### `print(self: Self) void`

Prints the contents of the ring buffer for debugging.



## License

MIT
