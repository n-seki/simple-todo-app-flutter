import 'package:flutter/material.dart';

import 'data.dart';
import 'db.dart';
import 'editor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: _TodoListPage(title: 'TODO'),
    );
  }
}

class _TodoListPage extends StatefulWidget {
  final String title;
  _TodoListPage({this.title});

  @override
  State<StatefulWidget> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<_TodoListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: DBProvider.db.selectAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error.toString()}");
            }
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, position) => Divider(color: Colors.grey),
              itemBuilder: (context, position) =>
                  _createTodo(context, snapshot.data[position])
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditorScreen())
            );
          }
      ),
    );
  }

  Widget _createTodo(BuildContext context, Todo todo) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(todo.title, style: TextStyle(fontSize: 24)),
            Text(todo.content, style: TextStyle(fontSize: 16), maxLines: 1,)
          ],
        ),
      )
    );
  }
}
