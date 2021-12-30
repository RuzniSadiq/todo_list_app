import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'models/task.dart';
import 'models/todo.dart';

//here wel create a method that wel use to create the database and tables
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  static Database? _db;
  //when the code is run if the table didnt exist it will create one else it wont
  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async{
        // Run the CREATE TABLE statement on the database.
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, "
            "description TEXT, taskdate TEXT, taskstarttime TEXT, taskendtime TEXT)");
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER,"
            " title TEXT, isDone INTEGER)");
      },
      version: 1,
    );
  }

  //Use of async and await enables the use of ordinary try / catch blocks around asynchronous code
  Future<int> insertTask(Task tasky) async {
    int taskId = 0;
    //opening up the database first
    //note the database() is the method we created above
    Database _db = await database();
    //perform some query nw
    //acessing the toMap method in the model class

    await _db.insert('tasks', tasky.toMap(),
  //conflict algorithm if the data conflicts we can abort the operation or replace or ignore it
        conflictAlgorithm: ConflictAlgorithm.replace).then((value)
    //its going to be the id of the task that we are submitting to the database
    {
      //set the task id to the value we get
      taskId = value;

    });
    return taskId;
  }


  Future<void> insertTodo(Todo todo) async {
    //opening up the database first
    //note the database() is the method we created above
    Database _db = await database();
    //perform some query nw
    //acessing the toMap method in the model class
    //conflict algorithm if the data conflicts we can abort the operation or replace or ignore it
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  //update task getting the id and setting the string we set
  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  //update task description getting the id and setting the string we set
  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }


  //update task date getting the id and setting the string we set
  Future<void> updateTaskDate(int id, String taskdate) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET taskdate = '$taskdate' WHERE id = '$id'");
  }

  //update task start time getting the id and setting the string we set
  Future<void> updateTaskStartTime(int id, String taskstarttime) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET taskstarttime = '$taskstarttime' WHERE id = '$id'");
  }

  //update task end time getting the id and setting the string we set
  Future<void> updateTaskEndTime(int id, String taskendtime) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET taskendtime = '$taskendtime' WHERE id = '$id'");
  }

  //update todoo (check/uncheck) getting the id and setting the string we set
  Future<void> updateTodoDone(int? id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }


  Future<List<Task>>? getTasks() async {
    Database _db = await database();
    //We want to query the tasks table
    List<Map<String, dynamic>> taskMap = await _db.rawQuery("SELECT * FROM tasks ORDER BY taskdate");
    //return as a list generate the list
    //1st argument - length of the list from the task map
    //2nd argument - value itself
    return List.generate(taskMap.length, (index) {
      //creating a task model
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          taskdate: taskMap[index]['taskdate'],
          taskstarttime: taskMap[index]['taskstarttime'],
          taskendtime: taskMap[index]['taskendtime']);
    });
  }



  //get todoo items
  Future<List<Todo>>? getTodo(int taskId) async {
    Database _db = await database();

    //We want to query the todoo table
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    //return as a list generate the list
    //1st argument - length of the list from the todoo map
    //2nd argument - value itself
    return List.generate(todoMap.length, (index) {
      //creating a task model
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone'],

      );
    });
  }
  

  //delete task, delete from task table where id matches the id we pass here
  //delete todoo, delete from todoo table where id matches the id we pass here
  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

  Future<List> allTasks() async{
    Database db = await database();
    //db.rawQuery('select * from courses');
    return db.query('tasks');
  }
}
