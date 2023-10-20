# tiny-parquet

A library that reads parquet files, written in zig.

- [x] Enumerators used in parquet metadata
- [x] Reader for files
  - [x] on local disk
  - [ ] on AWS S3
  - [ ] on google cloud storage
  - [ ] on azure blob
- [ ] Metadata
  - [x] Statistics
  - [ ] SchemaElement
  - [ ] DataPageHeader
  - [ ] DictionaryPageHeader
  - [ ] DataPageHeaderV2
  - [ ] PageHeader
  - [ ] KeyValue
  - [ ] SortingColumn
  - [ ] PageEncodingStats
  - [ ] ColumnMetaData
  - [ ] ColumnChunk
  - [ ] RowGroup
  - [ ] ColumnOrder
  - [ ] PageLocation
  - [ ] OffsetIndex
  - [ ] ColumnIndex
  - [ ] FileMetaData
- [ ] Data types
  - [ ] DecimalType
  - [ ] TimeUnit
  - [ ] TimestampType
  - [ ] TimeType
  - [ ] IntType
  - [ ] LogicalType
- [ ] Decompression
- [ ] Reader
