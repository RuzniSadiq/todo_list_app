import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/models/todo.dart';

import 'package:to_do_app/screens/homepage.dart';
import 'package:to_do_app/screens/todoitempage.dart';

import '../database_helper.dart';
import '../widgets.dart';

class Taskpage extends StatefulWidget {
  //creating a field so we can revceive the id
  //final int? id;
  //1.retrieving the task here
  Task? task;

  Taskpage({required this.task});

  Taskpage.hs(this.task);


  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
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

  String? _taskDescription = "";

  String? _taskdate;
  //String? _taskstarttime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String? _taskstarttime;
  String? _taskendtime;

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
    if (widget.task != null) {
      //if task is not null set visibility to true
      _contentVisible = true;

      _tasktitle = widget.task!.title;
      _taskId = widget.task!.id;
      _todotitle = widget.task!.title;

      _taskDescription = widget.task!.description;
      _taskdate = widget.task!.taskdate;
      _taskstarttime = widget.task!.taskstarttime;
      _taskendtime = widget.task!.taskendtime;




    }

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

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTimes,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (_pickedDate != null) {
      setState(() {
        _dateTimes = _pickedDate;
        _taskdateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
        //String? n = DateFormat("hh:mm a").format(_pickedtime);
      });
    }
  }

  //DateTime _timeonly = DateTime.now();
  //TimeOfDay newtime = TimeOfDay.now();

  _selectedTodoStartTime(BuildContext context) async {
    var _pickedtime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: const TimeOfDay(
            hour: 10,
            minute: 9,
        ),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: false), child: childWidget!);
        });
    if (_pickedtime != null) {
      setState(() {

        MaterialLocalizations localizations = MaterialLocalizations.of(context);
        String formattedTime = localizations.formatTimeOfDay(_pickedtime, alwaysUse24HourFormat: false);
        _taskstarttimeController.text = formattedTime;

      });
    }
  }


  _selectedTodoEndTime(BuildContext context) async {
    var _pickedtime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: const TimeOfDay(
          hour: 10,
          minute: 9,
        ),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: false), child: childWidget!);
        });
    if (_pickedtime != null) {
      setState(() {

        MaterialLocalizations localizations = MaterialLocalizations.of(context);
        String formattedTime = localizations.formatTimeOfDay(_pickedtime, alwaysUse24HourFormat: false);
        _taskendtimeController.text = formattedTime;

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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Container(
                        child: (_taskId==0)
            ?Text(
                          "Create New Task",
                          style: TextStyle(
                              fontSize: 50,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        )

                        :Text(
                          "View or Update Task",
                          style: TextStyle(
                              fontSize: 50,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        //24
                        top: 10.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        children: [
                          //inkwell is gesturedetector which gives a nice ripple effect
                          InkWell(
                            onTap: () {
                              //print("Click the back button");
                              //Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Homepage()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Image(
                                image: AssetImage(
                                  "assets/images/back_arrow_icon.png",
                                ),
                              ),
                            ),
                          ),


                          //since it requires a fixed size we are gonna wrap it with expanded widget
                          Expanded(
                            //text field here
                            child: TextField(
                                focusNode: _titleFocus,
                                //check if we have received any value
                                onSubmitted: (value) async {
                                  //when submit call our database class
                                  //checking if the value is not empty
                                  if (value != "") {
                                //check if the task we received from the homepage is null
                                    //if the task is null then we create a new task
                                    if (widget.task == null) {
                                      DatabaseHelper _dbHelper =
                                          DatabaseHelper();
                                      //create an instance of task model
                                      Task _newTask = Task(
                                        title: value,
                                      );
                                      //insert the _newTask created above
                                      // we are going to get the task id here
                                      _taskId =
                                          await _dbHelper.insertTask(_newTask);
                                      print("New task has been created successfully");
                                      setState(() {
                                        //show other stuff
                                        _contentVisible = true;
                                    //set the task title in the UI to the value we entered
                                        _tasktitle = value;
                                      });
                                      print(
                                          "The new task and the id is: $_taskId");
                                    } else {
                                      //if the task is not null then if the value is changed
                                      //update the task title
                                      await _dbHelper.updateTaskTitle(
                                          _taskId!, value);
                                      _tasktitle = value;
                                      print("Updated the task");
                                    }
                                    //focusing the cursor to next field
                                    //which is description
                                    _descriptionFocus.requestFocus();


                                  }
                                },
                                //in the text field adding a controller\
                                //3.using this we can provide default text
                                //default text will be task title
                                controller: TextEditingController()
                                  ..text = _tasktitle!,
                                decoration: const InputDecoration(
                                  hintText: "Enter task title",
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF211551),
                                )),
                          ),
                        ],
                      ),
                    ),
                    //text field of description beginning
                    //using visibility description goes away
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: TextField(
                          focusNode: _descriptionFocus,
                          onSubmitted: (value) async {
                            if (value != "") {
                              //if the task id is not 0 then surely update the description
                              if (_taskId != 0) {
                                //call dbhelper updatedescription method
                                await _dbHelper.updateTaskDescription(
                                    _taskId!, value);
                                print("Description has been updated successfully");
                                //update the task description variable
                                _taskDescription = value;
                              }
                            }
                            //focus to task date field after submit
                            _taskdateFocus.requestFocus();
                          },

                          //in the text field adding a controller\
                          //3.using this we can provide default text
                          //default text will be description title
                          controller: TextEditingController()
                            ..text = (_taskDescription =
                                _taskDescription == null
                                    ? ""
                                    : _taskDescription)!,

                          decoration: const InputDecoration(
                            hintText: "Enter Description for the task...",
                            border: InputBorder.none,
                            //adding padding inside the widget rather than wrapping the widget with padding
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //since it requires a fixed size we are gonna wrap it with expanded widget
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: TextField(
                          focusNode: _taskdateFocus,
                          //readOnly: true,
                          enableInteractiveSelection: false,
                          //focusNode: _descriptionFocus,
                          onSubmitted: (value) async {
                            if (value != "") {
                              //if the task id is not 0 then surely update the description
                              if (_taskId != 0) {
                                //DateTime dt = DateTime.parse(value);
                                //_taskdateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);

                                if (DateTime.tryParse(value) != null) {
                                  //call dbhelper updatedescription method
                                  await _dbHelper.updateTaskDate(
                                      _taskId!, value);

                                  //update the task edscription variable
                                  _taskdate = value;
                                  print("Task Date has been updated successfully");
                                } else {
                                  print("Enter a valid date");
                                }
                              }
                            }

                            _taskstarttimeFocus.requestFocus();
                          },

                          //in the text field adding a controller\
                          //3.using this we can provide default text
                          //default text will be description title
                          // controller: TextEditingController()
                          //   ..text = (_taskdate =
                          //   _taskdate == null
                          //       ? ""
                          //       : _taskdate)!,
                          controller: _taskdateController,

                          decoration: InputDecoration(
                              hintText: (_taskdate = _taskdate == null
                                  ? "Pick a date"
                                  : _taskdate),
                              border: InputBorder.none,
                              //adding padding inside the widget rather than wrapping the widget with padding

                              //labelText: 'Date',
                              prefixIcon: InkWell(
                                onTap: () {
                                  _selectedTodoDate(context);
                                },
                                child: Icon(Icons.calendar_today, color: Colors.redAccent,),
                              )

                              //adding padding inside the widget rather than wrapping the widget with padding

                              ),
                        ),
                      ),
                    ),










                    //start time
                    //since it requires a fixed size we are gonna wrap it with expanded widget
                    Row(
                      children: [
                        Visibility(
                          visible: _contentVisible,
                          child: Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                //focusNode: _taskstarttimeFocus,
                                //readOnly: true,
                                enableInteractiveSelection: false,

                                focusNode: _taskstarttimeFocus,
                                onSubmitted: (value) async {
                                  if (value != "") {
                                    //if the task id is not 0 then surely update the description
                                    if (_taskId != 0) {
                                      //DateTime dt = DateTime.parse(value);
                                      //_taskdateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);


                                        //call dbhelper updatedescription method
                                        await _dbHelper.updateTaskStartTime(
                                            _taskId!, value);

                                        //update the task edscription variable
                                        _taskstarttime = value;
                                        print("oi i think");

                                    }
                                  }

                                  _taskendtimeFocus.requestFocus();
                                },

                                //in the text field adding a controller\
                                //3.using this we can provide default text
                                //default text will be description title
                                // controller: TextEditingController()
                                //   ..text = (_taskdate =
                                //   _taskdate == null
                                //       ? ""
                                //       : _taskdate)!,
                                controller: _taskstarttimeController,

                                decoration: InputDecoration(
                                    hintText: (_taskstarttime = _taskstarttime == null
                                        ? "Pick start time"
                                        : _taskstarttime),
                                    border: InputBorder.none,
                                    //adding padding inside the widget rather than wrapping the widget with padding

                                    //labelText: 'Date',
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        _selectedTodoStartTime(context);
                                      },
                                      child: Icon(Icons.access_time_rounded, color: Colors.orangeAccent),
                                    )

                                  //adding padding inside the widget rather than wrapping the widget with padding

                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _contentVisible,
                          child: const Text(
                            "-",
                            style: TextStyle(
                                fontSize: 38,
                                height: 1.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
                            ),
                          ),
                        ),
                        //end time
                        //since it requires a fixed size we are gonna wrap it with expanded widget
                        Visibility(
                          visible: _contentVisible,
                          child: Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                //focusNode: _taskstarttimeFocus,
                                //readOnly: true,
                                enableInteractiveSelection: false,
                                focusNode: _taskendtimeFocus,
                                onSubmitted: (value) async {
                                  if (value != "") {
                                    //if the task id is not 0 then surely update the description
                                    if (_taskId != 0) {
                                      //DateTime dt = DateTime.parse(value);
                                      //_taskdateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);


                                      //call dbhelper updatedescription method
                                      await _dbHelper.updateTaskEndTime(
                                          _taskId!, value);

                                      //update the task edscription variable
                                      _taskendtime = value;
                                      print("end time pass");

                                    }
                                  }

                                  _todoFocus.requestFocus();
                                },

                                //in the text field adding a controller\
                                //3.using this we can provide default text
                                //default text will be description title
                                // controller: TextEditingController()
                                //   ..text = (_taskdate =
                                //   _taskdate == null
                                //       ? ""
                                //       : _taskdate)!,
                                controller: _taskendtimeController,

                                decoration: InputDecoration(
                                    hintText: (_taskendtime = _taskendtime == null
                                        ? "Pick end time"
                                        : _taskendtime),

                                    border: InputBorder.none,
                                    //adding padding inside the widget rather than wrapping the widget with padding

                                    //labelText: 'Date',
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        _selectedTodoEndTime(context);
                                      },
                                      child: Icon(Icons.access_time_rounded, color: Colors.orangeAccent),
                                    )

                                  //adding padding inside the widget rather than wrapping the widget with padding

                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    ///Container for Task Category
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(

                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey[100]!,

                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ///Container for Icon
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromRGBO(255, 250, 240, 1)
                                ),
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.web_asset,
                                  color: Colors.orangeAccent,
                                ),
                              ),

                              ///For spacing
                              SizedBox(width: 24,),

                              ///For Text
                              Text("Work",
                                style: TextStyle(
                                    fontSize: 18,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[700]
                                ),
                              ),

                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Todoitemspage(taskId: _taskId!, tasktitle: _tasktitle,)));

                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),




                  ],
                ),
                //this positioned part is for the delete button, same as add except right is 24.0
                Visibility(
                  visible: _contentVisible,
                  child: Positioned(
                    bottom: 24.0,
                    right: 24.0,
                    child: GestureDetector(
                      //if we tap on floating action button delete task
                      onTap: () async {
                        //check if task id does not equal to 0
                        if (_taskId != 0) {
                          //call the deleteTask method
                          await _dbHelper.deleteTask(_taskId);
                          print("Task has been deleted successfully");
                          //go back to homepage
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Homepage()));
                        }
                      },
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color(0xFFFE3577)),
                        child: const Image(
                          image: AssetImage(
                            "assets/images/delete_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
