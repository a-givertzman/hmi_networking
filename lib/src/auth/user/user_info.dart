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
    const groupKey = 'group';
    final List<String> groups = switch(map) {
      {groupKey: []} => [],
      {groupKey: final group} => group is List ? group.cast<String>() : [group.toString()],
      _ => [],
    };
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