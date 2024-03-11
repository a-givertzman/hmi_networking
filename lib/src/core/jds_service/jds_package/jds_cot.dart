/// Json data storage - Cause of transmission
enum JdsCot {
  inf,
  act,
  actCon,
  actErr,
  req,
  reqCon,
  reqErr;
  ///
  const JdsCot();
  ///
  factory JdsCot.fromString(String cot) {
    return switch(cot) {
      'Inf' => inf,
      'Act' => act,
      'ActCon' => actCon,
      'ActErr' => actErr,
      'Req' => req,
      'ReqCon' => reqCon,
      'ReqErr' => reqErr,
      _ => throw ArgumentError.value(cot, 'cot'),
    };
  }
  //
  @override
  String toString() {
    return switch(this) {
      inf => 'Inf',
      act => 'Act',
      actCon => 'ActCon',
      actErr => 'ActErr',
      req => 'Req',
      reqCon => 'ReqCon',
      reqErr => 'ReqErr',
    };
  }
}