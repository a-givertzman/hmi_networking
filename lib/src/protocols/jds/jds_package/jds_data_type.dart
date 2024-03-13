///
enum JdsDataType {
  boolean,
  integer,
  float,
  string;
  ///
  const JdsDataType();
  ///
  factory JdsDataType.fromString(String type) {
    return switch(type) {
      'Bool' => JdsDataType.boolean,
      'Int' => JdsDataType.integer,
      'Float' => JdsDataType.float,
      'String' => JdsDataType.string,
      _ => throw ArgumentError.value(type, 'type'),
    };
  }
  //
  @override
  String toString() {
    return switch(this) {      
      JdsDataType.boolean => 'Bool',
      JdsDataType.integer => 'Int',
      JdsDataType.float => 'Float',
      JdsDataType.string => 'String',
    };
  }
}