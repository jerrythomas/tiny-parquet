# SchemaElement

The SchemaElement structure has the following fields:

- type: An optional field of type Type (which is an enum).
  type_length: An optional int32 field.
  repetition_type: An optional field of type FieldRepetitionType.
  name: A required string field.
  num_children: An optional int32 field.
  converted_type: An optional field of type ConvertedType (another enum).
  scale: An optional int32 field.
  precision: An optional int32 field.
  field_id: An optional int32 field.
  logicalType: An optional field of type LogicalType.
  Next, let's read the buffer to extract the raw byte values for
