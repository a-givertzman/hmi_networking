import 'jds_point_config.dart';

///
class JdsPointConfigs {
  final Map<String, JdsPointConfig> _map;
  ///
  const JdsPointConfigs(Map<String, JdsPointConfig> map) : _map = map;
  ///
  factory JdsPointConfigs.fromMap(Map<String, dynamic> map) {
    return JdsPointConfigs(
      map.map(
        (pointName, submap) => MapEntry(
          pointName, 
          JdsPointConfig.fromMap(submap as Map<String, dynamic>),
        ),
      ),
    );
  }
  ///
  JdsPointConfig? get(String name) => _map[name];
  ///
  List<String> get names => _map.keys.toList();
}