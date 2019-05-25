class Todo {
  int id; // autoincrement
  String title;
  String content;
  Todo({this.title, this.content});

  factory Todo.fromJson(Map<String, dynamic> json) {
    Todo todo = Todo(
      title: json["title"],
      content: json["content"]
    );
    todo.id = json["id"];
    return todo;
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content
    };
  }
}