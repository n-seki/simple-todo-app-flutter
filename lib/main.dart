import 'package:flutter/material.dart';

import 'data.dart';
import 'db.dart';
import 'detail.dart';
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

  List<Todo> todoList;

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
            if (!snapshot.hasData) {
              return Center(
                child: Text("No Todo or Loading Now"),
              );
            }
            this.todoList = snapshot.data;
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, position) => Divider(height: 1,color: Colors.grey),
              itemBuilder: (context, position) =>
                  _createTodo(context, position)
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

  Widget _createTodo(BuildContext context, int index) {
    final Todo todo = this.todoList[index];
    return Dismissible(
      key: Key(todo.id.toString()),
      onDismissed: (direction) {
        DBProvider.db.delete(todo);
        setState(() {
          this.todoList.removeAt(index);
        });
      },
      background: Container(color: Colors.red,),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoDetailScreen(todo: todo)));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(todo.title, style: TextStyle(fontSize: 24), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(todo.content, style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis,)
            ],
          ),
        ),
      )
    );
  }
}
