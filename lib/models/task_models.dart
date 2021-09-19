class Task{
  int? id;
  String title;
  String description;
  String completed;

  Task({this.id, required this.title, required this.description, required this.completed});

  Map<String,dynamic> convertirAMap(){
    return {
      "id":id,
      "title":title,
      "description":description,
      "completed":completed,
    };

  }
}