import 'package:flutter/material.dart';

import 'data.dart';

class TodoDetailScreen extends StatelessWidget {
  TodoDetailScreen({Key key, @required this.todo}): super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(todo.title, style: TextStyle(fontSize: 20)),
                    Divider(color: Colors.grey[200]),
                    Text(todo.content, style: TextStyle(fontSize: 16)),
                  ],
                ),
              )
            ],
          )

        )
    );
  }
}