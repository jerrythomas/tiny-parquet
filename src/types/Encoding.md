# Encodings

Encodings supported by Parquet. Not all encodings are valid for all types. These
enums are also used to specify the encoding of definition and repetition levels.
See the accompanying doc for the details of the more complicated encodings.

Default encoding.

- BOOLEAN - 1 bit per value. 0 is false, 1 is true.
- INT32 - 4 bytes per value. Stored as little-endian.
- INT64 - 8 bytes per value. Stored as little-endian.
- FLOAT - 4 bytes per value. IEEE. Stored as little-endian.
- DOUBLE - 8 bytes per value. IEEE. Stored as little-endian.
- BYTE_ARRAY - 4 byte length stored as little endian, followed by bytes.
- FIXED_LEN_BYTE_ARRAY - Just the bytes.

## Encoding Enum

### PLAIN: 0

### PLAIN_DICTIONARY: 2

> Deprecated: Dictionary encoding.

The values in the dictionary are encoded in the plain type.

- In a data page use RLE_DICTIONARY instead.
- In a Dictionary page use PLAIN instead.

### RLE: 3

Group packed run length encoding. Usable for definition/repetition levels encoding and Booleans (on one bit: 0 is false, 1 is true).

### BIT_PACKED: 4

Bit packed encoding. This can only be used if the data has a known max width. Usable for definition/repetition levels encoding.

### DELTA_BINARY_PACKED: 5

Delta encoding for integers. This can be used for int columns and works best on sorted data.

### DELTA_LENGTH_BYTE_ARRAY: 6

Encoding for byte arrays to separate the length values and the data. The lengths are encoded using DELTA_BINARY_PACKED.

### DELTA_BYTE_ARRAY: 7

Incremental-encoded byte array. Prefix lengths are encoded using DELTA_BINARY_PACKED. Suffixes are stored as delta length byte arrays.

### RLE_DICTIONARY: 8

Dictionary encoding: the ids are encoded using the RLE encoding.

### BYTE_STREAM_SPLIT: 9

Encoding for floating-point data. K byte-streams are created where K is the size in bytes of the data type. The individual bytes of an FP value are scattered to the corresponding stream and the streams are concatenated. Leads to better compression afterwards.
