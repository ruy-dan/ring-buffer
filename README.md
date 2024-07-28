# ring-buffer

A Ring Buffer implementation with a fixed-size buffer that does not allocate memory dynamically.

```
zig fetch --save https://github.com/ruy-dan/zig-ring-buffer/archive/refs/tags/v0.0.1.tar.gz
```

## Usage

```zig
const RingBuffer = @import("ring-buffer").RingBuffer;

var buffer = try RingBuffer([]const u8, .{ .capacity = 2 }).init();
try buffer.write("hello");
try buffer.write("circular");

var output: []const u8 = undefined;
try buffer.read(&output); // hello

try buffer.read(&output); //circular

try buffer.write("world");
try buffer.read(&output); // world
```

## API

```zig
pub fn RingBuffer(comptime T: type, opts: Opts) !type
```
Creates a new RingBuffer with a fixed-size buffer.
The default capacity is 1024. An optional capacity can be set through opts.
e.g: `const Opts = struct { capacity: usize = 1024 };`
Returns an error if the capacity is not a power of two.


### Methods

#### `isEmpty() bool`

Returns `true` if the ring buffer is empty, `false` otherwise.

#### `isFull() bool`

Returns `true` if the ring buffer is full, `false` otherwise.

#### `size() usize`

Returns the number of elements in the ring buffer.

#### `write(self: *Self, item: T) !void`

Writes an item to the ring buffer. Returns an error if the buffer is full.

#### `read(self: *Self, output: *T) !void`

Reads an item from the ring buffer. Returns an error if the buffer is empty.

#### `clear(self: *Self) void`

Clears the ring buffer.

#### `print(self: Self) void`

Prints the contents of the ring buffer.



## License

MIT
