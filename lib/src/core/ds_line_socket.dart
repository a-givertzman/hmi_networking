import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/line_socket.dart';

///
class DsLineSocket implements LineSocket{
  static final _log = const Log('DsLineSocket')..level = LogLevel.info;
  bool _isActive = false;
  bool _isConnected = false;
  bool _cancel = false;
  Socket? _socket;
  final String _ip;
  final int _port;
  final _controller = StreamController<Uint8List>();
  ///
  DsLineSocket({
    required String ip, 
    required int port,
  }) : 
    _ip = ip,
    _port = port;
  //
  @override
  bool get isConnected => _isConnected;
  //
  @override
  bool get isActive => !_cancel;
  //
  @override
  Stream<Uint8List> get stream => _stream();
  ///
  Stream<Uint8List> _stream() {
    if (!_isActive) {
      _isActive = true;
      _controller.onListen = _listenSocket;
      return _controller.stream;
    }
    throw Failure.connection(
      message: 'Ошибка в методе $DsLineSocket._stream: already connected to socket.', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  void _listenSocket() async {
    _log.debug('[._listenSocket] activated.');
    while (!_cancel) {
      if (!_isConnected) {
        await Socket.connect(_ip, _port, timeout: const Duration(seconds: 3))
        .then((socket) async {
          _socket = socket;
          _isConnected = true;
          _log.info('[._listenSocket] connected socket addr: ${socket.address} \tport ${socket.port}');
          _controller.add(
            _buildConnectionStatus(_isConnected),
          );
          try {
            await for (final event in socket) {
              _controller.add(event);
            }
          } catch (error) {
            _log.debug('[._listenSocket] stream error: $error');
            await _closeSocket(socket);
            _controller.addError(error);
          }
          _log.debug('[._listenSocket] stream done');
          _isConnected = false;
          _controller.add(
            _buildConnectionStatus(_isConnected),
          );
        })
        .catchError((error, stackTrace) {
          _log.info('[._listenSocket] error: $error');
          // _log.debug('[._listenSocket] stackTrace: $stackTrace');
          _isConnected = false;
          _controller.add(
            _buildConnectionStatus(_isConnected),
          );
        });
      }
      _log.debug('[._listenSocket] cancel: $_cancel');
      if (!_cancel) {
        _log.debug('[._listenSocket] waiting...');
        await Future.delayed(const Duration(seconds: 3));
      }
    }
    _log.debug('[._listenSocket] exit.');
  }
  ///
  Uint8List _buildConnectionStatus(bool isConnected) {
    _log.debug('[._buildConnectionStatus] isConnected: $isConnected');
    return Uint8List.fromList(
      utf8.encode(
        DsDataPoint(
          type: DsDataType.bool, 
          name: DsPointName('/Local/Local.System.Connection'), 
          value: isConnected ? 1 : 0, 
          status: DsStatus.ok, 
          timestamp: DsTimeStamp.now().toString(),
        ).toJson(),
      ),
    );
  }
  //
  @override
  Result<bool> requestAll() {
    _controller.add(
      _buildConnectionStatus(_isConnected),
    );
    return const Result(data: true);
  }
  //
  @override
  Future<Result<bool>> send(List<int> data) async {
    final socket = _socket;
    // TODO Better implementation of this feature to be released
    if(socket == null) {
      _log.debug('[.send] failed, socket was: $socket');
      await Future.delayed(const Duration(milliseconds: 100));
      return Future.value(
        Result(
          error: Failure.connection(
            message: 'Not connected', 
            stackTrace: StackTrace.current,
          ),
        ),
      );
    } else {
      _log.debug('[.send] event: $data');
      try {
        if (_isConnected) {
          socket.add(data);
          return Future.value(const Result(data: true));
        }
        return Future.value(
          Result(error: Failure(
            message: 'Ошибка в методе $runtimeType.send: socket is not connected',
            stackTrace: StackTrace.current
          ))
        );
      } catch (error) {
        _log.debug('[.send] error: $error');
        await _closeSocket(socket);
        return Future.value(
          Result(
            error: Failure.connection(
              message: '$error', 
              stackTrace: StackTrace.current,
            ),
          ),
        );          
      }
    }
  }
  ///
  Future<void> _closeSocket(Socket? socket) async {
    try {
      await _socket?.close();
      _socket?.destroy();
    } catch (error) {
      _log.warning('[.close] error: $error');
    }
  }
  //
  @override
  Future close() async {
    _cancel = true;
    await _closeSocket(_socket);
    await _controller.close();
    _isActive = false;
  }
}
