import 'package:flutter/material.dart';

import 'data.dart';
import 'db.dart';

class EditorScreen extends StatefulWidget {
  final Todo todo;
  EditorScreen({Key key, this.todo}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String title = 'Add';
    if (widget.todo != null) {
      titleController.text = widget.todo.title;
      contentController.text = widget.todo.content;
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
              enabled: widget.todo == null,
              autofocus: widget.todo == null,
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
                enabled: widget.todo == null,
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
            if (widget.todo == null)
              FlatButton(
                child: Text("Add"),
                onPressed: () {
                  if (!_checkInput()) {
                    return;
                  }
                  Future<int> result = insert();
                  result.then((rowNum) {
                    print("insert success: $rowNum");
                    Navigator.pop(context);
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