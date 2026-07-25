import 'package:druna_app/core/theme/druna_theme.dart';
import 'package:druna_app/models/models.dart';
import 'package:druna_app/repositories/druna_repository.dart';
import 'package:druna_app/shared/ui/druna_widgets.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({required this.repository, super.key});
  final DrunaRepository repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<FriendInfo>? _requests;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final requests = await widget.repository.incomingRequests();
      if (mounted) {
        setState(() {
          _requests = requests;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _accept(FriendInfo person, bool accept) async {
    try {
      if (accept) {
        await widget.repository.acceptFriend(person.username);
      } else {
        await widget.repository.rejectFriend(person.username);
      }
      await _load();
    } catch (error) {
      if (mounted) showMessage(context, error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Уведомления')),
    body: RefreshIndicator(
      onRefresh: _load,
      child: _error != null
          ? ListView(
              children: [
                const SizedBox(height: 120),
                StatePanel(
                  title: 'Не удалось обновить',
                  message: _error!,
                  onRetry: _load,
                ),
              ],
            )
          : _requests == null
          ? ListView(
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            )
          : _requests!.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                StatePanel(
                  title: 'Всё спокойно',
                  message:
                      'Новые заявки и изменения появятся здесь после обновления.',
                  icon: Icons.notifications_none_rounded,
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _requests!.length,
              separatorBuilder: (_, _) =>
                  const Divider(color: DrunaColors.line),
              itemBuilder: (context, index) {
                final person = _requests![index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: DrunaAvatar(name: person.name, index: person.id),
                  title: Text(
                    '${person.name} хочет дружить',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('@${person.username}'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: 'Отклонить',
                        onPressed: () => _accept(person, false),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: DrunaColors.muted,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Принять',
                        onPressed: () => _accept(person, true),
                        icon: const Icon(Icons.check_rounded),
                      ),
                    ],
                  ),
                );
              },
            ),
    ),
  );
}
