import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/screens/searchpage.dart';
import 'package:to_do_app/screens/taskpage.dart';
import 'package:to_do_app/widgets.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

//state
class _HomepageState extends State<Homepage> {

  //creating an instance or object

  DatabaseHelper _dbHelper = DatabaseHelper();



  @override
  Widget build(BuildContext context) {

    //returning scaffold
    // Scaffold will give you a default struture properties like appbar, body, etc
    return Scaffold(

      //safe area to not go beyond safe area and keep in screen
      body: SafeArea(
        //container keeps objects in place like div
        child: Container(

          //expanding the container to the whole page initially it only had a portion in left
            width: double.infinity,
            //adding padding in this container for all sides
            //padding: EdgeInsets.all(24.0),
            //adding padding in this container for vertical horizontal only
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            //assigning background color
            color: Color(0xFFF6F6F6),

            //so we can place things above each other
            child: Stack(
              children: [
                Column(

                  //making everything from let to right on the screen
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(


                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(

                              //width:80,
                              height: 50,


                                child: Image(

                                  image: AssetImage(
                                    "assets/images/logo.png",


                                  ),
                                  //height: 80,




                                ),





                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 32.0,
                              top: 32.0,


                            ),
                            child: const Align(

                              alignment: Alignment.center,
                              child: Text(
                                "My Tasks",
                                style: TextStyle(
                                  color: Color(0xFF868290),
                                  fontSize: 28.0,
                                  height: 1.5,
                                ),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        children: [
                          GestureDetector(
                            //if we tap on floating actionbutton go to task page
                            onTap: () {
                              Navigator.push(
                                context,
                                //here only we will be creating a new task
                                MaterialPageRoute(builder: (context) => Searchpage()),
                                //when we head back to main page this will set the state
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              width: 30.0,
                              height: 30.0,

                              child: const Image(
                                image: AssetImage(
                                  "assets/images/search.png",

                                ),

                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                "Search for tasks..."
                            ),
                          ),
                        ],
                      ),
                    ),
                    //this container we have out logo



                    //wrapping the listview in the expanded widget so
                    // it wont show an error and we can insert a list in the column
                    Expanded(


                      //creating a list so we can have a list here
                      child: FutureBuilder<List<Task>>(
                        //providing empty data
                          initialData: [],
                          //calling the gettasks method to display all tasks
                          future: _dbHelper.getTasks(),
                          //this is gonna give us context and snapshot
                          builder: (context, snapshot) {

                            return ScrollConfiguration(
                              behavior: NoGlowBehaviour(),

                              //using the snapshot create a new listview here
                              child: ListView.builder(


                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    print("All tasks returned");
                                    //wrapping the taskcard widget inside a gesture detector
                                    return GestureDetector(

                                      //detect on tap whenever we press on this task
                                      onTap: () {
                                        //what we want to do is get the id from the snapshot above and
                                        //navigate to that card task page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            //send the user to the task pagge
                                            //here we can provide the id from the snapshot
                                              builder: (context) => Taskpage(
                                                task: snapshot.data![index],
                                              )),
                                        ).then((value){
                                          setState(() {
                                          });
                                        });
                                      },
                                      child: TaskCardWidget(
                                        title: snapshot.data![index].title,
                                        desc: snapshot.data![index].description,
                                        date: snapshot.data![index].taskdate,
                                      ),
                                    );
                                  }),
                            );
                          }

                        //placing the taskcardwidget here so that need not place a whole lot of code here

                      ),
                    )
                  ],
                ),
                //wrap the container inside the position widget so we can place it anywhere in the screen
                //the floating action button or plus mark button
                Positioned(
                  bottom: 24.0,
                  right: 0.0,
                  child: GestureDetector(
                    //if we tap on floating actionbutton go to task page
                    onTap: () {
                      Navigator.push(
                        context,
                        //here only we will be creating a new task
                        MaterialPageRoute(builder: (context) => Taskpage(task: null,)),
                        //when we head back to main page this will set the state
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        //color: Color(0xFF7349FE)
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                        ),
                      ),
                      child: const Image(
                        image: AssetImage(
                          "assets/images/add_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
