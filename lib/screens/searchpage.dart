import 'package:flutter/material.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/screens/taskpage.dart';
import 'package:to_do_app/screens/homepage.dart';
import 'package:to_do_app/widgets.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  _SearchpageState createState() => _SearchpageState();
}

//state
class _SearchpageState extends State<Searchpage> {

  DatabaseHelper? helper;
  List allTasks = [];
  List items = [];
  TextEditingController toSearch = TextEditingController();

  @override
  void initState() {

    super.initState();
    helper = DatabaseHelper();
    helper!.allTasks().then((data){
      allTasks = data;
      items = allTasks;
    });
  }



  //getting the value entered in the text field
  void filterSeach(String query) async{
    //assign all the tasks
    var dummySearchList = allTasks;
    if(query.isNotEmpty){
      //providing empty data
      var dummyListData = [];
      //for each loop
      dummySearchList.forEach((item){
        print("Searching");
        var taskz = Task.fromMap(item);
        //match by the task title
        if(taskz.title!.toLowerCase().contains(query.toLowerCase())){
          dummyListData.add(item);
        }
      });
      //set the state
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    }else{
      setState(() {
        items = [];
        items = allTasks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        print("back button");
        return false;
      },
    //returning scaffold
    // Scaffold will give you a default struture properties like appbar, body, etc
    child: Scaffold(
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

                  children: [
                    //this container we have out logo

                    //inkwell is gesturedetector which gives a nice ripple effect
                    Row(


                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(

                            width:30,
                            height: 20,

                            child: InkWell(

                              onTap: () {
                                //print("Click the back button");
                                //Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Homepage()));
                              },

                              child: const Image(

                                image: AssetImage(
                                  "assets/images/back_arrow_icon.png",


                                ),



                              ),

                            ),



                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 32.0,
                            top: 32.0,
                            left: 20.0,

                          ),
                          child: Align(

                              alignment: Alignment.topLeft,
                            child: Text(
                              "Search Task",
                              style: TextStyle(
                                  fontSize: 40,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800]
                              ),


                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (value){
                          setState(() {
                            //passing the entered value to the
                            //filter search method
                            filterSeach(value);

                          });
                        },
                        controller: toSearch,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),),),
                    ),

                    //wrapping the listview in the expanded widget so
                    // it wont show an error and we can insert a list in the column
                    Expanded(

                      //creating a list so we can have a list here

                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            Task tasks = Task.fromMap(items[i]);
                            //wrapping the taskcard widget inside a gesture detector
                            return GestureDetector(
                              //detect on tap whenever we press on this task
                              onTap: () {
                                //what we want to do is get the id from the snapshot above and
                                //navigate to that card task page
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Taskpage.hs(tasks,))).then((value) {
                                  setState(() {});
                                });
                              },


                              child: TaskCardWidget(
                                title: tasks.title,
                                desc: tasks.description,
                                date: tasks.taskdate,

                              ),
                            );
                          }),


                      //placing the taskcardwidget here so that need not place a whole lot of code here

                    ),
                  ],
                ),
                //wrap the container inside the position widget so we can place it anywhere in the screen
                //the floating action button or plus mark button

              ],
            )),
      ),
    ),
    );
  }
}