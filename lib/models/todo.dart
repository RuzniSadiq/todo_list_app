class Todo{

  final int? id;
  final String ? title;
  final int ? isDone;
  final int ? taskId;

  Todo({this.id, this.taskId, this.title, this.isDone});

  // a method that wil convert the object to a map
  //map of key type string and value type dynamic meaning any type of value
  //this method will help create the map of the todo object
  Map<String, dynamic> toMap(){
    //this method will return everything mapped storing everything in the correct field
    return{
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
    };
  }
}


