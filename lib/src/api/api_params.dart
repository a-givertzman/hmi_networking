import 'dart:convert';

class ApiParams {
  final Map<String, dynamic> _map;
  ApiParams(Map<String, dynamic> params)
    : _map = Map.from(params)
  {
    _map['procedureName'] =  _map['procedureName'] ?? '';
    _map['tableName'] = _map['tableName'] ?? '';
    _map['params'] = _map['params'] ?? '0';
    _map['keys'] = _map['keys'] ?? ['*'];
    _map['values'] = _map['values'] ?? [[]];
    _map['groupBy'] = _map['groupBy'] ?? '';
    _map['orderBy'] = _map['orderBy'] ?? ['id'];
    _map['order'] = _map['order'] ?? ['ASC'];
    _map['where'] = _map['where'] ?? [];
    _map['limit'] = _map['limit'] ?? [];
  }
  const ApiParams.empty() 
    : _map = const <String, dynamic>{};
  ApiParams updateWith(Map<String, dynamic> params) {
    final newParams = Map<String, dynamic>.from(_map);
    params.forEach((key, value) {
      newParams[key] = value;
    });
    return ApiParams(newParams);
  }
  Map<String, String> toMap() {
    final Map<String, String> map = {};
    _map.forEach((key, value) {
      map[key] = json.encode(value);
    });
    return map;
  }
  String toJson() {
    final Map<String, String> map = {};
    _map.forEach((key, value) {
      map[key] = json.encode(value);
    });
    return json.encode(map);
  }
}
