import 'dart:io';

import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo2wish/TodoList.dart';

const APP_TITLE = 'Todo2Wish';

ObjectDB todoDB;
ObjectDB wishDB;
ObjectDB accountDB;

void main() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  todoDB = ObjectDB(appDocDir.path + '/todos.db');
  await todoDB.open();

  runApp(new TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: APP_TITLE,
      home: new TodoList(title: APP_TITLE, todoDB: todoDB),
    );
  }
}
