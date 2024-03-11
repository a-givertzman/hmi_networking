///
enum JdsDataType {
  bool,
  int,
  float,
  string;
  ///
  const JdsDataType();
  ///
  factory JdsDataType.fromString(String type) {
    return switch(type) {
      'Bool' => JdsDataType.bool,
      'Int' => JdsDataType.int,
      'Float' => JdsDataType.float,
      'String' => JdsDataType.string,
      _ => throw ArgumentError.value(type, 'type'),
    };
  }
  //
  @override
  String toString() {
    return switch(this) {      
      JdsDataType.bool => 'Bool',
      JdsDataType.int => 'Int',
      JdsDataType.float => 'Float',
      JdsDataType.string => 'String',
    };
  }
}