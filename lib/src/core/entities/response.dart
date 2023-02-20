///
class Response<T> {
  final int _errCount;
  final String _errDump;
  final T? _data;
  ///
  const Response({
    int errCount = 0,
    String errDump = '',
    T? data,
  }):
    _errCount = errCount,
    _errDump = errDump,
    _data = data;
  ///
  bool get hasData => _data != null;
  ///
  bool get hasError => _errCount > 0;
  ///
  String get errorMessage => _errDump;
  ///
  int get errorCount => _errCount;
  ///
  T? get data => _data;
  //
  @override
  String toString() {
    return 'data: $_data\nerrCount: $_errCount\nerrDump: "$_errDump"';
  }
}