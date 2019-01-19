import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

final String tableData = 'data';
final String columnId = '_id';
final String columnType = 'type';
final String columnTitle = 'title';
final String columnSince = 'since';
final String columnDone = 'done';
final String columnValue = 'value';
final String columnSummary = 'summary';

enum TodoType { task, wish }

class Todo {
  int id;
  TodoType type;
  String title;
  DateTime since;
  DateTime done;
  int value;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnType: type.index,
      columnTitle: title,
      columnSince: since.millisecondsSinceEpoch,
      columnDone: done != null ? done.millisecondsSinceEpoch : null,
      columnValue: value,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    print(map);
    id = map[columnId];
    type = TodoType.values[map[columnType]];
    title = map[columnTitle];
    since = DateTime.fromMillisecondsSinceEpoch(map[columnSince]);
    done = map[columnDone] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[columnDone])
        : null;
    value = map[columnValue] ?? calculatePoints(since);
  }

  int calculatePoints(DateTime since) {
    Duration duration = DateTime.now().difference(since);

    if (duration.inDays > 6) {
      return duration.inDays ~/ 7 + 3;
    } else if (duration.inDays < 4) {
      return duration.inHours ~/ 24;
    } else {
      return 3;
    }
  }
}

class DataProvider {
  final ValueNotifier<int> balance = ValueNotifier(null);
  Database _db;

  Future open(String path) async {
//    await deleteDatabase(path);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $tableData ( 
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $columnType INTEGER NOT NULL,
          $columnTitle TEXT NOT NULL,
          $columnSince INTEGER NOT NULL,
          $columnDone INTEGER,
          $columnValue INTEGER
        )
        ''');
      },
    );
  }

  Future<Todo> insertTodo(Todo todo) async {
    todo.id = await _db.insert(tableData, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id, [TodoType type = TodoType.task]) async {
    List<Map> maps = await _db.query(
      tableData,
      where: '$columnId = ? AND $columnType = ?',
      whereArgs: [id, type.index],
    );
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getTodos([TodoType type = TodoType.task]) async {
    List<Map> maps = await _db.query(
      tableData,
      where: '$columnType = ?',
      whereArgs: [type.index],
      orderBy: '$columnDone, $columnSince',
    );

    return maps.map((item) => Todo.fromMap(item)).toList();
  }

  Future<int> deleteTodo(int id, [TodoType type = TodoType.task]) async {
    return await _db.delete(
      tableData,
      where: '$columnId = ? AND $columnType = ?',
      whereArgs: [id, type.index],
    );
  }

  Future<int> updateTodo(Todo todo) async {
    return await _db.update(
      tableData,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> fetchBalance() async {
    List<Map> result = await _db.query(
      tableData,
      columns: ['SUM($columnValue) as $columnSummary'],
      where: '$columnDone IS NOT NULL',
    );

    balance.value = result.first[columnSummary] ?? 0;
  }

  Future close() async => _db.close();
}
