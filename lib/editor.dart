import 'package:flutter/material.dart';

import 'data.dart';
import 'db.dart';

class EditorScreen extends StatefulWidget {
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              autofocus: true,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input Title"
              ),
            ),
            Divider(color: Colors.grey[200]),
            Expanded(
              child:  TextField(
                controller: contentController,
                minLines: 1,
                maxLines: 20,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Input TODO",
                ),
              ),
            ),
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