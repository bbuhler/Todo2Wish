import 'package:flutter/material.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/NewTaskView.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _tasks;

  void loadTasksFromDb() async {
    List<Todo> tasks = await widget.db.getTodos();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  void initState() {
    this.loadTasksFromDb();
    super.initState();
  }

//  @override
//  void dispose() async {
//    await widget.todoDB.close();
//    super.dispose();
//  }

  void _addTodoItem(String task) async {
    if (task.length > 0) {
      Todo todo = Todo();
      todo.title = task;
      todo.type = TodoType.task;
      todo.since = DateTime(2018, 12, 24);
      await widget.db.insertTodo(todo);
      this.loadTasksFromDb();
    }
  }

  Widget _buildTodoList() {
    if (this._tasks == null) {
      return Center(child: Text('Loading...'));
    } else {
      return ListView(
          children: this._tasks.map((task) => _buildTodoItem(task)).toList());
    }
  }

  int _calculatePoints(DateTime since) {
    Duration duration = DateTime.now().difference(since);

    if (duration.inDays > 6) {
      return duration.inDays ~/ 7 + 3;
    } else if (duration.inDays < 4) {
      return duration.inHours ~/ 24;
    } else {
      return 3;
    }
  }

  Widget _buildTodoItem(Todo task) {
    return ListTile(
      leading: task.done != null
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(task.title),
      trailing: Text(_calculatePoints(task.since).toString()),
      onTap: () => _toggleTodoItem(task),
      onLongPress: () => _promptRemoveTodoItem(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
      body: _buildTodoList(),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: NewTaskView(
          onCreate: _addTodoItem,
        ).build,
      ),
    );
  }

  void _removeTodoItem(Todo task) async {
    await widget.db.deleteTodo(task.id);
    this.loadTasksFromDb();
  }

  void _toggleTodoItem(Todo task) {
    if (task.done == null) {
      task.done = DateTime.now();
      task.value = _calculatePoints(task.since);
    } else {
      task.done = null;
      task.value = null;
    }
    widget.db.updateTodo(task);
    this.loadTasksFromDb();
  }

  void _promptRemoveTodoItem(Todo task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry "${task.title}"?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('DELETE'),
              onPressed: () {
                _removeTodoItem(task);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
