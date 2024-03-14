///
class DsPointAddress {
  final int offset;
  final int? bit;
  ///
  const DsPointAddress({this.offset = 0, this.bit});
  ///
  factory DsPointAddress.fromMap(Map<String, dynamic> map) {
    return DsPointAddress(
      offset: map['offset'],
      bit: map['bit'],
    );
  }
  ///
  Map<String, dynamic> toMap() => {
    'offset': offset,
    'bit': bit,
  };
}