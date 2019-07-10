import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/TodoListView.dart';
import 'package:todo2wish/views/WishListView.dart';
import 'package:todo2wish/widgets/AccountButton.dart';

import 'Localizations.dart';

DataProvider db;

void main() async {
  String dbPath = await getDatabasesPath();
  db = DataProvider();

  await db.open(path.join(dbPath, 'todos-sql.db'));

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          MainLocalizations.of(context).title,
      localizationsDelegates: [
        const MainLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('de'),
      ],
      theme: Theme.of(context).copyWith(
        primaryColor: Colors.teal[500],
        primaryColorLight: Colors.teal[300],
        primaryColorDark: Colors.teal[800],
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
        accentColor: Colors.teal[800],
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(color: Colors.amber[300]),
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
              display1: TextStyle(fontSize: 16.0, color: Colors.pink[600]),
              display2: TextStyle(fontSize: 16.0, color: Colors.teal[500]),
            ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal[700],
        ),
        errorColor: Colors.pink[600],
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(MainLocalizations.of(context).title),
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
              Tab(text: MainLocalizations.of(context).tasksTitle),
              Tab(text: MainLocalizations.of(context).wishesTitle),
            ],
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18.0),
            indicatorWeight: 4.0,
            indicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
