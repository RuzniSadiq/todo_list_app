import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/models/todo.dart';

import 'package:to_do_app/screens/homepage.dart';

import '../database_helper.dart';
import '../widgets.dart';

class Todoitemspage extends StatefulWidget {
  //creating a field so we can revceive the id
  //final int? id;
  //1.retrieving the task here
  int? taskId;
  String? tasktitle;

  Todoitemspage({required this.taskId, required this.tasktitle});



  @override
  _TodoitemspageState createState() => _TodoitemspageState();
}

class _TodoitemspageState extends State<Todoitemspage> {
  //initialize database
  DatabaseHelper _dbHelper = DatabaseHelper();

  var _taskdateController = TextEditingController();
  var _taskstarttimeController = TextEditingController();
  var _taskendtimeController = TextEditingController();

  //retrieve title and description
  //2.assigning the title to the variable _tasktitle
  String? _tasktitle = "";
  String? _todotitle = "";
  String? newnewdate = "";
  int? _taskId = 0;


  //using these focus nodes what we can do is when w esubmit the title,
  //as soon as we finish procesing our data we can the send the user to the next text field
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  late FocusNode _taskdateFocus;
  late FocusNode _taskstarttimeFocus;
  late FocusNode _taskendtimeFocus;

  //visibility of all the elements
  bool _contentVisible = false;


  //once we receive the id we are gona print it in the task page
  @override
  void initState() {

    _taskId = widget.taskId;
    _tasktitle = widget.tasktitle;

    //initialize focus nodes

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    _taskdateFocus = FocusNode();
    _taskstarttimeFocus = FocusNode();
    _taskendtimeFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    //dispose all focus nodes here
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    _taskdateFocus.dispose();
    _taskstarttimeFocus.dispose();
    _taskendtimeFocus.dispose();

    super.dispose();
  }

  DateTime _dateTimes = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "$_tasktitle - Add ToDo",
                      style: TextStyle(
                          fontSize: 50,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800]),
                    ),
                  ),
                  //text field of description beginning
                  //using visibility description goes away



                  FutureBuilder<List<Todo>>(
                    //providing empty data
                    initialData: [],
                    //calling the gettodo method in the database class
                    //we are passing the taskid here to show ONLY the
                    //todoo items available for that specific task
                    future: _dbHelper.getTodo(_taskId!),
                    //this is gonna give us context and snapshot
                    builder: (context, snapshot) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              //setting the data
                              return GestureDetector(
                                onTap: () async {
                                  //switch the toodo completion state
                                  // print("Toodo Done: ${snapshot.data![index].isDone}");
                                  if (snapshot.data![index].isDone == 0) {
                                    //i think await refreshes state
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data![index].id, 1);
                                    setState(() {});
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data![index].id, 0);
                                    setState(() {});
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  //calling the todowidget class
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          decoration: BoxDecoration(
                            //If is done is true show original color else show transparent color (check or uncheck box)
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              // if is done is true don't show border else show border
                              border: Border.all(
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
                        //because we are creating inside a row
                        Expanded(
                          child: TextField(
                            focusNode: _todoFocus,
                            //make the todoo text field blank
                            controller: TextEditingController()..text = "",
                            //when submitting the toodo item
                            onSubmitted: (value) async {
                              //checking if the value is not empty
                              if (value != "") {
                                //check the task id is not null
                                if (_taskId != 0) {
                                  //create an instance of todoo model
                                  //adding values
                                  Todo _newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    //getting the current task id
                                    taskId: _taskId,
                                  );
                                  //insert the todoo item by calling the class
                                  await _dbHelper.insertTodo(_newTodo);
                                  print("Todo item inserted successfully");
                                  setState(() {});
                                  //focus on the toodo text field again
                                  _todoFocus.requestFocus();

                                  print("Creating new todo");
                                } else {
                                  print("Task does not exist");
                                }
                                //store the data using the database helper class

                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
