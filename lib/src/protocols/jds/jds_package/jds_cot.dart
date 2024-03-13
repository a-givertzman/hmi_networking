///
/// Cause of transmission of JDS package
enum JdsCot {
  /// 
  /// Information
  inf,
  /// 
  /// Command
  act,
  /// 
  /// Command completed
  actCon,
  /// 
  /// Command failed
  actErr,
  /// 
  /// Request
  req,
  /// 
  /// Request completed
  reqCon,
  /// 
  /// Request failed
  reqErr;
  ///
  /// Cause of transmission of JDS package
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