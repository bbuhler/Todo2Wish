import 'package:flutter/material.dart';
import 'package:todo2wish/TodoList.dart';

const APP_TITLE = 'Todo2wish';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: APP_TITLE,
      home: new TodoList(),
    );
  }
}