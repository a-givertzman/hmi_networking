///
class UserInfo {
  final String id;
  final List<String> groups;
  final String name;
  final String login;
  final String password;
  ///
  const UserInfo({
    required this.id, 
    required this.groups, 
    required this.name, 
    required this.login, 
    required this.password,
  });
  ///
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    final List<String> groups = [];
    if (map.containsKey('group')) {
      groups.add(map['group']);
    }
    if (map.containsKey('groups') && groups.isEmpty) {
      final serializedGroups = map['groups'] as List<dynamic>;
      groups.addAll(serializedGroups.cast<String>());
    }
    if(groups.isEmpty) {
      throw ArgumentError.value(map, 'map');
    }
    return UserInfo(
      id: "${map['id']}", 
      groups: groups, 
      name: map['name'], 
      login: map['login'], 
      password: map['password'] ?? map['pass'],
    );
  }
  ///
  Map<String, dynamic> asMap() => {
    'id': id,
    'groups': groups,
    'name': name,
    'login': login,
    'password': password,
  };
}