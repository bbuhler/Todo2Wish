import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/BaseListView.dart';
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
    setState(() => _tasks = tasks);
  }

  @override
  void initState() {
    loadTasksFromDb();
    super.initState();
  }

  void _addTodoItem(String task, String dateSince) async {
    if (task.length > 0) {
      Todo todo = Todo();
      todo.title = task;
      todo.type = TodoType.task;
      todo.since = DateTime.tryParse(dateSince) ?? DateTime.now();
      await widget.db.insertTodo(todo);
      loadTasksFromDb();
    }
  }

  Widget _buildTodoItem(Todo task) {
    return ListTile(
      leading: task.done != null
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(task.title),
      trailing: task.value == 0
          ? null
          : Text(
              task.value.toString(),
              style: TextStyle(color: Colors.redAccent),
            ),
      onTap: () => _toggleTodoItem(task),
      onLongPress: () => _promptRemoveTodoItem(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tasks != null
        ? BaseList(
            onAddItem: _pushAddTodoScreen,
            openTitle: Text('TASKS'),
            openItems: _tasks
                .where((item) => item.done == null)
                .map(_buildTodoItem)
                .toList(),
            doneTitle: Text('DONE'),
            doneItems: _tasks
                .where((item) => item.done != null)
                .map(_buildTodoItem)
                .toList(),
          )
        : Center(child: Text('Loading...'));
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
    loadTasksFromDb();
  }

  void _toggleTodoItem(Todo task) {
    if (task.done == null) {
      task.done = DateTime.now();
      task.value = task.calculatePoints(task.since);
      _promptToggleTodoItem(task, 'ERLEDIGT');
    } else if (task.calculatePoints(task.since) == task.value) {
      task.done = null;
      _promptToggleTodoItem(task, 'UNERLEDIGT');
    }
  }

  void _promptToggleTodoItem(Todo task, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(action),
              onPressed: () {
                widget.db.updateTodo(task);
                widget.db.fetchBalance();
                loadTasksFromDb();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _promptRemoveTodoItem(Todo task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry?'),
          content: Text(task.title),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
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
