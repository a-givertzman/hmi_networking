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
      final serializedGroup = map['group'];
      if(serializedGroup is List) {
        groups.addAll(serializedGroup.cast<String>());
      } else {
        groups.add(serializedGroup);
      }
    }
    if(groups.isEmpty) {
      throw ArgumentError.value(map, 'map', '"group" in not provided');
    }
    return UserInfo(
      id: "${map['id']}", 
      groups: groups, 
      name: map['name'], 
      login: map['login'], 
      password: map['pass'],
    );
  }
  ///
  Map<String, dynamic> asMap() => {
    'id': id,
    'group': groups,
    'name': name,
    'login': login,
    'pass': password,
  };
}