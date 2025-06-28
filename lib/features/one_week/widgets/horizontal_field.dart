import 'package:druna_app/features/shared_widgets/days_of_week/view_model/field.dart';
import 'package:druna_app/theme/theme.dart' show darkTheme;
import 'package:flutter/material.dart';

class HorizontalField extends StatefulWidget {
  
  const HorizontalField({
    super.key,
  });

  @override
  State<HorizontalField> createState() => _HorizontalFieldState();
}

class _HorizontalFieldState extends State<HorizontalField> {
  final ScrollController _scrollController = ScrollController();  // unused

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: 700,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: 48 * 7,
          itemBuilder: (context, index) {
            final data = Field().generateData(
              7,
            ); // перенести в тело класса
            final String time = data[index]["time"];
            final double barWidth = data[index]["barWidth"]
                .toDouble();

            if(index < 2) {
              return SizedBox(width: 40,);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 2,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: index % 2 == 0 ? 38 : 0,
                    child: Text(
                      time,
                      style: darkTheme.textTheme.labelSmall,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: index % 2 == 0 ? 0 : 5),
                          width: barWidth,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}