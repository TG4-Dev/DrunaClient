import 'dart:async';

import 'package:druna_app/core/theme/druna_theme.dart';
import 'package:druna_app/models/models.dart';
import 'package:druna_app/repositories/druna_repository.dart';
import 'package:druna_app/shared/ui/druna_widgets.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({required this.repository, super.key});
  final DrunaRepository repository;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _search = TextEditingController();
  List<FriendInfo>? _friends;
  List<FriendInfo>? _incoming;
  List<FriendInfo> _results = const [];
  String? _error;
  bool _searching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final values = await Future.wait([
        widget.repository.listFriends(),
        widget.repository.incomingRequests(),
      ]);
      if (!mounted) return;
      setState(() {
        _friends = values[0];
        _incoming = values[1];
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _runSearch(value),
    );
  }

  Future<void> _runSearch(String value) async {
    setState(() => _searching = true);
    try {
      final result = await widget.repository.searchFriends(value.trim());
      if (mounted) setState(() => _results = result);
    } catch (error) {
      if (mounted) showMessage(context, error.toString(), error: true);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _act(Future<void> Function() action, String success) async {
    try {
      await action();
      if (!mounted) return;
      showMessage(context, success);
      await _load();
    } catch (error) {
      if (mounted) showMessage(context, error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Друзья'),
      bottom: TabBar(
        controller: _tabs,
        tabs: [
          const Tab(text: 'Все'),
          Tab(
            text:
                'Заявки${(_incoming?.isNotEmpty ?? false) ? ' · ${_incoming!.length}' : ''}',
          ),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabs,
      children: [
        RefreshIndicator(
          onRefresh: _load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: _search,
                    onChanged: _onSearch,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Найти по нику',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searching
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              if (_search.text.trim().length >= 2)
                _PeopleSliver(
                  people: _results,
                  emptyText: 'Никого не нашли',
                  actionBuilder: (person) => IconButton(
                    tooltip: 'Добавить ${person.name}',
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    onPressed: () => _act(
                      () =>
                          widget.repository.sendFriendRequest(person.username),
                      'Заявка отправлена',
                    ),
                  ),
                )
              else if (_error != null)
                SliverFillRemaining(
                  child: StatePanel(
                    title: 'Не удалось загрузить друзей',
                    message: _error!,
                    onRetry: _load,
                  ),
                )
              else if (_friends == null)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                _PeopleSliver(
                  people: _friends!,
                  emptyText: 'Здесь появятся твои друзья',
                  actionBuilder: (person) => PopupMenuButton<String>(
                    onSelected: (_) => _act(
                      () => widget.repository.deleteFriend(person.username),
                      'Друг удалён',
                    ),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Удалить из друзей'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        RefreshIndicator(
          onRefresh: _load,
          child: _incoming == null
              ? ListView(
                  children: const [
                    SizedBox(height: 180),
                    Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                )
              : _incoming!.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    StatePanel(
                      title: 'Новых заявок нет',
                      message:
                          'Когда кто-то захочет добавить тебя, заявка появится здесь.',
                      icon: Icons.people_outline_rounded,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _incoming!.length,
                  separatorBuilder: (_, _) =>
                      const Divider(color: DrunaColors.line),
                  itemBuilder: (context, index) {
                    final person = _incoming![index];
                    return _PersonRow(
                      person: person,
                      trailing: Wrap(
                        spacing: 2,
                        children: [
                          IconButton(
                            tooltip: 'Отклонить',
                            icon: const Icon(
                              Icons.close_rounded,
                              color: DrunaColors.muted,
                            ),
                            onPressed: () => _act(
                              () => widget.repository.rejectFriend(
                                person.username,
                              ),
                              'Заявка отклонена',
                            ),
                          ),
                          IconButton(
                            tooltip: 'Принять',
                            icon: const Icon(Icons.check_rounded),
                            onPressed: () => _act(
                              () => widget.repository.acceptFriend(
                                person.username,
                              ),
                              'Теперь вы друзья',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

class _PeopleSliver extends StatelessWidget {
  const _PeopleSliver({
    required this.people,
    required this.emptyText,
    required this.actionBuilder,
  });
  final List<FriendInfo> people;
  final String emptyText;
  final Widget Function(FriendInfo person) actionBuilder;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: StatePanel(
          title: emptyText,
          message: 'Поиск друзей работает по точному нику.',
          icon: Icons.person_search_rounded,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      sliver: SliverList.separated(
        itemCount: people.length,
        separatorBuilder: (_, _) => const Divider(color: DrunaColors.line),
        itemBuilder: (context, index) => _PersonRow(
          person: people[index],
          trailing: actionBuilder(people[index]),
        ),
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.person, required this.trailing});
  final FriendInfo person;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: DrunaAvatar(name: person.name, index: person.id),
    title: Text(
      person.name.isEmpty ? person.username : person.name,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
    subtitle: Text(
      '@${person.username}',
      style: const TextStyle(color: DrunaColors.muted),
    ),
    trailing: trailing,
  );
}
