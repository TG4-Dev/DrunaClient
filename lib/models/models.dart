class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    username: json['username']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    avatarUrl: (json['avatarURL'] ?? json['avatarUrl'])?.toString(),
  );

  final int id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
}

class DrunaEvent {
  const DrunaEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.userId,
    this.groupId,
  });

  factory DrunaEvent.fromJson(Map<String, dynamic> json) => DrunaEvent(
    id:
        ((json['eventID'] ?? json['eventId'] ?? json['id']) as num?)?.toInt() ??
        0,
    userId: (json['userID'] as num?)?.toInt(),
    groupId: (json['groupID'] as num?)?.toInt(),
    title: json['title']?.toString() ?? 'Без названия',
    startTime: DateTime.parse(json['startTime'] as String).toLocal(),
    endTime: DateTime.parse(json['endTime'] as String).toLocal(),
    type: json['type']?.toString() ?? 'personal',
  );

  final int id;
  final int? userId;
  final int? groupId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  Map<String, dynamic> toRequest() => {
    'title': title,
    'startTime': startTime.toUtc().toIso8601String(),
    'endTime': endTime.toUtc().toIso8601String(),
    'type': type,
  };
}

class FriendInfo {
  const FriendInfo({
    required this.id,
    required this.name,
    required this.username,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) => FriendInfo(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    username: json['username']?.toString() ?? '',
  );

  final int id;
  final String name;
  final String username;
}

class GroupSummary {
  const GroupSummary({
    required this.id,
    required this.name,
    this.ownerId,
    this.members = const [],
  });

  factory GroupSummary.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['members'];
    return GroupSummary(
      id:
          ((json['groupID'] ?? json['groupId'] ?? json['id']) as num?)
              ?.toInt() ??
          0,
      name: json['name']?.toString() ?? 'Группа',
      ownerId: ((json['ownerID'] ?? json['ownerId']) as num?)?.toInt(),
      members: rawMembers is List
          ? rawMembers
                .whereType<Map>()
                .map(
                  (item) =>
                      FriendInfo.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
    );
  }

  final int id;
  final String name;
  final int? ownerId;
  final List<FriendInfo> members;
}

class FreeSlot {
  const FreeSlot({required this.start, required this.end});

  factory FreeSlot.fromJson(Map<String, dynamic> json) => FreeSlot(
    start: DateTime.parse(json['start'] as String).toLocal(),
    end: DateTime.parse(json['end'] as String).toLocal(),
  );

  final DateTime start;
  final DateTime end;
}

List<Map<String, dynamic>> mapList(dynamic value) => value is List
    ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
    : const [];
