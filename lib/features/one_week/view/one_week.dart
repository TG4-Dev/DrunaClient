import 'package:druna_app/features/one_week/widgets/friends_vertikal_list_bottom.dart';
import 'package:druna_app/features/one_week/widgets/horizontal_field.dart';
import 'package:druna_app/features/shared_widgets/days_of_week/view/list_days_of_week.dart';
import 'package:druna_app/features/shared_widgets/days_of_week/view_model/day.dart';
import 'package:druna_app/repositories/api/friends/friends_api.dart';
import 'package:druna_app/repositories/api/ping/ping_api.dart';
import 'package:druna_app/repositories/models/friends.dart';
import 'package:druna_app/theme/theme.dart';
import 'package:flutter/material.dart';

class OneWeekScreen extends StatefulWidget {
  const OneWeekScreen({super.key});

  @override
  State<OneWeekScreen> createState() => _OneWeekScreenState();
}

class _OneWeekScreenState extends State<OneWeekScreen> {
  final List<Day> daysOfWeek = DayModel.generateDaysOfWeek(7);
  final friendApi = FriendsApi();
  final pingApi = PingApi();
  List<FriendInfo>? _friendList;

  @override
  void initState() {
    _loadFriendList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
              Row(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
                      child: Text(
                        '${daysOfWeek[0].day.toUpperCase()} ${daysOfWeek[0].date}',
                        style: darkTheme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  // oval selector
                ],
              ),

              HorizontalField(),
            ],
          ),

          Positioned(
            top: 150, // Позиция сверху
            left: 5, // Отступ слева
            child: FriendListBottomWidget(friendList: _friendList),
          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 50,
                child: ListDaysOfWeek(daysOfWeek: daysOfWeek),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadFriendList() async {
    _friendList = await friendApi.getFriendsList(
      token:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTExNTIxNzgsImlhdCI6MTc1MTEwODk3OCwidXNlcl9pZCI6MX0.7YjEyJTfY63RkFlTg-_ph9OGUlpLAc6scOEvp67-1zM",
    );
    setState(() {});
  }
}
