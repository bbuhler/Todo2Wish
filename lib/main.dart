import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/TodoListView.dart';
import 'package:todo2wish/views/WishListView.dart';
import 'package:todo2wish/widgets/AccountButton.dart';

const APP_TITLE = 'Todo2Wish';

DataProvider db;

void main() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  db = DataProvider();

  await db.open(appDocDir.path + '/todos-sql.db');

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(APP_TITLE),
            actions: [AccountButton(db: db)],
          ),
          body: TabBarView(
            children: [
              TodoList(db: db),
              WishList(db: db),
            ],
          ),
          bottomNavigationBar: Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              tabs: [
                Tab(text: "Tasks"),
                Tab(text: "Wishes"),
              ],
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              indicatorWeight: 4.0,
              indicatorColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
