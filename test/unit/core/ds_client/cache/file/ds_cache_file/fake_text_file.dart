import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
class FakeTextFile implements TextFile {
  String contentText;
  final bool _isReadOk;
  ///
  FakeTextFile({
    this.contentText = '', 
    bool isReadOk = true,
  }) : _isReadOk = isReadOk;
  //
  @override
  Future<ResultF<String>> get content async {
    return _isReadOk ? Ok(contentText) : Err(Failure(message: '', stackTrace: StackTrace.empty));
  }
  //
  @override
  Future<void> write(String text) async {
    contentText = text;
  }
}