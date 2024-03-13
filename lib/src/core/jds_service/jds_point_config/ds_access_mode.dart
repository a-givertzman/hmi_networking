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
}