class Task {
   int? id;
   String ? title;
   String ? description;
   String? taskdate;
   String? taskstarttime;
   String? taskendtime;

  Task({this.id, this.title, this.description, this.taskdate, this.taskstarttime, this.taskendtime});

  Task.fromMap(Map<String,dynamic> data){
    id = data['id'];
    title = data['title'];
    description = data['description'];
    taskdate = data['taskdate'];
    taskstarttime = data['taskstarttime'];
    taskendtime = data['taskendtime'];
  }
  // a method that wil convert the object to a map
  //map of keytype string and value type dynamic meaning any type of value
  //this method will help create the map of the task object
  Map<String, dynamic> toMap(){
    //this method will return everything mapped storing everything in the correct field id in id field
    return{
      'id': id,
      'title': title,
      'description': description,
      'taskdate': taskdate,
      'taskstarttime': taskstarttime,
      'taskendtime': taskendtime,
    };
  }
}
