class FriendInfo {
  final int id;
  final String name;
  final String username;

  FriendInfo({
    required this.id,
    required this.name,
    required this.username,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    return FriendInfo(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }

  // Преобразование объекта обратно в JSON (опционально)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
    };
  }
}