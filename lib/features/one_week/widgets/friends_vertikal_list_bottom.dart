import 'package:druna_app/repositories/models/friends.dart';
import 'package:flutter/material.dart';

class FriendListBottomWidget extends StatefulWidget {
  final List<FriendInfo>? friendList;

  const FriendListBottomWidget({super.key, required this.friendList});

  @override
  FriendListBottomWidgetState createState() => FriendListBottomWidgetState();
}

class FriendListBottomWidgetState extends State<FriendListBottomWidget> {
  int _dividerPosition = 0;

  @override
  Widget build(BuildContext context) {
    int i = -1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Первый шарик (всегда на месте)
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(25),
          ),
        ),

        // Список шариков
        SizedBox(
          width: 70,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 5),
            itemCount: widget.friendList != null ? widget.friendList!.length + 1 : 1,
            itemBuilder: (context, index) {
              if (index == _dividerPosition) {
                return Container(color: Colors.grey, height: 3, width: 50);
              }

              i = index < _dividerPosition ? index : index - 1;

              return Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  ),
                  onPressed: () => _handleBallPress(index),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(child: Text(widget.friendList![i > -1 ? i : index].username)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleBallPress(int pressedIndex) {
    setState(() {
      print('index = $pressedIndex');
      print('pos = $_dividerPosition');
      if (pressedIndex < _dividerPosition) {
        // Шарик над полоской - перемещаем под полоску
        widget.friendList!.insert(_dividerPosition, widget.friendList![pressedIndex]);
        widget.friendList!.removeAt(pressedIndex);
        _dividerPosition--;
      } else if (pressedIndex >= _dividerPosition) {
        // Шарик под полоской - перемещаем на позицию сразу после первого шарика
        widget.friendList!.insert(_dividerPosition, widget.friendList![pressedIndex - 1]);
        widget.friendList!.removeAt(pressedIndex);
        _dividerPosition++;
      }
    });
  }
}
