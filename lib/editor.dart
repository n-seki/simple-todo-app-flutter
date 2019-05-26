import 'package:flutter/material.dart';

import 'data.dart';
import 'db.dart';

class EditorScreen extends StatefulWidget {
  final Todo todo;
  EditorScreen({Key key, this.todo}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState(todo: todo);
}

class _EditorScreenState extends State<EditorScreen> {
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();
  final Todo todo;
  _EditorScreenState({Key key, this.todo});

  bool isEditable;

  @override
  void initState() {
    super.initState();
    this.isEditable = this.todo == null;
    if (this.todo != null) {
      titleController.text = widget.todo.title;
      contentController.text = widget.todo.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Add';
    if (this.todo != null) {
      title = 'Edit';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              enabled: this.isEditable,
              autofocus: this.isEditable,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input Title"
              ),
              style: TextStyle(fontSize: 20),
            ),
            Divider(color: Colors.grey[200]),
            Expanded(
              child:  TextField(
                enabled: this.isEditable,
                controller: contentController,
                minLines: 1,
                maxLines: 20,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input TODO",
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (this.isEditable)
              FlatButton(
                child: Text(this.todo == null ? "Add" : "Update"),
                onPressed: () {
                  if (!_checkInput()) {
                    return;
                  }
                  Future<int> result = todo == null ? insert() : update();
                  result.then((rowNum) {
                    Navigator.pop(context);
                  });
                },
              ),
            if (!this.isEditable)
              FlatButton(
                child: Text("Enable Edit"),
                  onPressed: () {
                    setState(() {
                      this.isEditable = true;
                    });
                },
              )
          ],
        ),
      )
    );
  }

  Future<int> insert() async {
    final Todo todo = Todo(
      title: titleController.text,
      content: contentController.text
    );
    return await DBProvider.db.insert(todo);
  }

  Future<int> update() async {
    final Todo todo = Todo(
      title: titleController.text,
      content: contentController.text
    );
    todo.id = this.todo.id;
    return await DBProvider.db.update(todo);
  }

  bool _checkInput() {
    return titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}