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
      columnValue: value,
    };
    if (id != null) {
      map[columnId] = id;
    }
    if (done != null) {
      map[columnDone] = done.millisecondsSinceEpoch;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    print(map);
    id = map[columnId];
    type = TodoType.values[map[columnType]];
    title = map[columnTitle];
    value = map[columnValue];
    since = DateTime.fromMillisecondsSinceEpoch(map[columnSince]);
    done = map[columnDone] != null
        ? DateTime.fromMillisecondsSinceEpoch(map[columnDone])
        : null;
  }
}

class DataProvider {
  Database db;

  Future open(String path) async {
//    await deleteDatabase(path);

    db = await openDatabase(
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
    todo.id = await db.insert(tableData, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id, [TodoType type = TodoType.task]) async {
    List<Map> maps = await db.query(
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
    List<Map> maps = await db.query(
      tableData,
      where: '$columnType = ?',
      whereArgs: [type.index],
    );

    return maps.map((item) => Todo.fromMap(item)).toList();
  }

  Future<int> deleteTodo(int id, [TodoType type = TodoType.task]) async {
    return await db.delete(
      tableData,
      where: '$columnId = ? AND $columnType = ?',
      whereArgs: [id, type.index],
    );
  }

  Future<int> updateTodo(Todo todo) async {
    return await db.update(
      tableData,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> getBalance() async {
    List<Map> result = await db.query(
      tableData,
      columns: ['SUM($columnValue) as $columnSummary'],
      where: '$columnDone IS NOT NULL',
    );

    int summary = result.first[columnSummary];
    return summary == null ? 0 : summary;
  }

  Future close() async => db.close();
}
