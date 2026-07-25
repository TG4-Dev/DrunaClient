import 'package:druna_app/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('event DTO parses API identifiers and serializes UTC timestamps', () {
    final event = DrunaEvent.fromJson({
      'eventID': 12,
      'userID': 3,
      'groupID': 7,
      'title': 'Team sync',
      'startTime': '2026-06-17T14:00:00Z',
      'endTime': '2026-06-17T16:00:00Z',
      'type': 'meeting',
    });

    expect(event.id, 12);
    expect(event.groupId, 7);
    expect(event.toRequest()['startTime'], endsWith('Z'));
    expect(event.toRequest()['title'], 'Team sync');
  });

  test('group parsing tolerates missing members', () {
    final group = GroupSummary.fromJson({'groupId': 4, 'name': 'TG-4'});

    expect(group.id, 4);
    expect(group.members, isEmpty);
  });
}
