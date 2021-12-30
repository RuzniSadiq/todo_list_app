import 'package:flutter/material.dart';

//here we are creating the cards
class TaskCardWidget extends StatelessWidget {
  //adding the ? allows the variable to be nullable
  //the title variable is for the title
  final String? title;
  final String? desc;
  final String? date;

  //constructor
  TaskCardWidget({this.title, this.desc, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
        //get infinite width
        width: double.infinity,
        //changing the color of the task card widget
        padding: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 24.0,
        ),
        //adding margins between each cards
        margin: const EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            //you cant have color and border decoration separately! they should be together
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              //if title is null then set name to unnamed
              title ?? "(Unnamed Task)",

              style: const TextStyle(
                color: Color(0xFF211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Text(
                //if the description is null then set desc to the following
                desc ?? "No description added",
                style: const TextStyle(
                  color: Color(0xFF868290),
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Text(
                //if the description is null then set desc to the following
                date ?? "No date added",
                style: const TextStyle(
                  color: Color(0xFF868290),
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            )
          ],
        ));
  }
}

//same as our taskcard widget here we are creating toodo widget
class TodoWidget extends StatelessWidget {
  //const TodoWidget({Key? key}) : super(key: key);

  final String? text;
  final bool isDone;

  TodoWidget({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 16.0,
            ),
            decoration: BoxDecoration(
                //If is done is true show original color else show transparent color (check or uncheck box)
                color: isDone ? Color(0xFF7349FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                // if is done is true don't show border else show border
                border: isDone
                    ? null
                    : Border.all(
                        color: Color(0xFF868290),
                        width: 1.5,
                      )),
            width: 20.0,
            height: 20.0,
            child: const Image(
              image: AssetImage(
                "assets/images/check_icon.png",
              ),
            ),
          ),
          //to prevent text overflow
          Flexible(
            child: Text(
              text ?? "(Unnamed Todo)",
              style: TextStyle(
                color: isDone ? Color(0xFF211551) : Color(0xFF868290),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//removes all the default styling so we dont have the glow when scrolled
class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
