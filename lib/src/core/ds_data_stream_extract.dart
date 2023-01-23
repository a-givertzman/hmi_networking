import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'ds_data_point_extracted.dart';
///
///
class StatusColors {
  final Color on;
  final Color off;
  final Color error;
  final Color obsolete;
  final Color invalid;
  final Color timeInvalid;

  const StatusColors({
    required this.on, 
    required this.off, 
    required this.error, 
    required this.obsolete, 
    required this.invalid, 
    required this.timeInvalid,
  });
}
///
class DsDataStreamExtract<T> {
  final List<StreamController<DsDataPointExtracted<T>>> _controllers = [];
  final Stream<DsDataPoint<T>>? _stream;
  final StatusColors _statusColors;
  bool _isActive = false;
  ///
  DsDataStreamExtract({
    required Stream<DsDataPoint<T>>? stream,
    required StatusColors statusColors,
  }) : 
    _stream = stream,
    _statusColors = statusColors;
  ///
  void _onListen() {
    if (!_isActive) {
      _isActive = true;
      final stream = _stream;
      if (stream != null) {
        stream.listen((point) {
          _controllers.forEach((controller) {    
            if (!controller.isClosed) {
              controller.add(
                DsDataPointExtracted(
                  value: point.value, 
                  status: point.status,
                  color: _buildColor(point),
                ),
              );
            }
          });
        });        
      }
    }
  }
  ///
  Stream<DsDataPointExtracted<T>> get stream {
    final controller = StreamController<DsDataPointExtracted<T>>();
    _controllers.add(controller);
    controller.onListen = () {
      _controllers.add(controller);
      _onListen();
    };
    controller.onCancel = () {
      controller.close();
      _controllers.remove(controller);
    };
    return controller.stream;
  }
  ///
  /// расчитывает текущий цвет в зависимости от point.status и point.value
  Color _buildColor(DsDataPoint<T> point) {
    Color clr = _statusColors.invalid;
    if (point.status == DsStatus.ok) {
      clr = point.value == DsDps.off.value
        ? _statusColors.off
        : point.value == DsDps.on.value
          ? _statusColors.on
          : point.value == DsDps.transient.value
            ? _statusColors.error
            : clr;
    }
    if (point.status == DsStatus.obsolete) {
      clr = _statusColors.obsolete;
    }
    if (point.status == DsStatus.invalid) {
      clr = _statusColors.invalid;
    }
    if (point.status == DsStatus.timeInvalid) {
      clr = _statusColors.timeInvalid;
    }
    return clr;
  }  
}