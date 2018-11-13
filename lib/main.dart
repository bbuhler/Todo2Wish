import 'dart:io';

import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo2wish/TodoList.dart';
import 'package:todo2wish/WishList.dart';

const APP_TITLE = 'Todo2Wish';

ObjectDB accountDB;
ObjectDB todoDB;
ObjectDB wishDB;

void main() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  accountDB = ObjectDB(appDocDir.path + '/account.db');
  await accountDB.open();

  todoDB = ObjectDB(appDocDir.path + '/todos.db');
  await todoDB.open();

  wishDB = ObjectDB(appDocDir.path + '/wishes.db');
  await wishDB.open();

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
              actions: [
                FlatButton.icon(
                  icon: Icon(Icons.stars, color: Colors.yellow),
                  label: Text("152",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                TodoList(todoDB: todoDB),
                WishList(wishDB: wishDB),
              ],
            ),
            bottomNavigationBar: Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                tabs: [
                  Tab(
                    text: "Tasks",
                  ),
                  Tab(
                    text: "Wishes",
                  ),
                ],
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 18.0),
                indicatorWeight: 4.0,
                indicatorColor: Colors.white,
              ),
            ),
          ),
        ));
  }
}
