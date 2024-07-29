# ring-buffer

A Ring Buffer implementation with a fixed-size buffer.

```
zig fetch --save https://github.com/ruy-dan/zig-ring-buffer/archive/refs/tags/v0.0.1.tar.gz
```

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

## API

```zig
pub fn RingBuffer(comptime T: type, opts: Opts) !type
```
Creates a new RingBuffer with a fixed-size buffer.
The capacity can be set through opts. Otherwise, the default capacity is set to 1024.
Returns an error if the capacity is not a power of two.

`const Opts = struct { capacity: usize = 1024 };`


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
