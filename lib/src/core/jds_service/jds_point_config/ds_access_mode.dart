///
enum DsAccessMode {
  read,
  write,
  readWrite;
  ///
  const DsAccessMode();
  ///
  factory DsAccessMode.fromString(String mode) {
    return switch(mode) {
      'r'  => read,
      'w'  => write,
      'rw' => readWrite,
      _ => throw ArgumentError.value(mode, 'mode'),
    };
  }
  ///
  @override
  String toString() => switch(this) {
    DsAccessMode.read => 'r',
    DsAccessMode.write => 'w',
    DsAccessMode.readWrite => 'rw',
  };
}