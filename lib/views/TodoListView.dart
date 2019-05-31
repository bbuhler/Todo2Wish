import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/BaseList.dart';
import 'package:todo2wish/views/NewTaskView.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _tasks;

  void reloadFromDb() async {
    List<Todo> tasks = await widget.db.getTodos();
    setState(() => _tasks = tasks);
  }

  @override
  void initState() {
    reloadFromDb();
    super.initState();
  }

  void _showAddItemScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: NewTaskView(
          onCreate: _addItem,
        ).build,
      ),
    );
  }

  void _addItem(String task, String dateSince) async {
    if (task.length > 0) {
      Todo todo = Todo();
      todo.title = task;
      todo.type = TodoType.task;
      todo.since = DateTime.tryParse(dateSince) ?? DateTime.now();
      await widget.db.insertTodo(todo);
      reloadFromDb();
    }
  }

  Future<bool> _isToggleDoneAllowed(Todo task) async {
    return task.done == null && await _toggleItemConfirm(task, 'DONE');
  }

  Future<bool> _isToggleUndoneAllowed(Todo task) async {
    return task.done != null &&
        task.calculatePoints(task.since) == task.value &&
        widget.db.balance.value - task.value > 0 &&
        await _toggleItemConfirm(task, 'UNDONE');
  }

  void _toggleItem(Todo task) async {
    if (await _isToggleDoneAllowed(task)) {
      task.done = DateTime.now();
      task.value = task.calculatePoints(task.since);
      widget.db.updateTodo(task);
    } else if (await _isToggleUndoneAllowed(task)) {
      task.done = null;
      widget.db.updateTodo(task);
    }

    widget.db.fetchBalance();
    reloadFromDb();
  }

  Future<bool> _toggleItemConfirm(Todo task, String action) {
    Completer<bool> completer = Completer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                completer.complete(false);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(action),
              onPressed: () {
                completer.complete(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  void _removeItem(Todo task) async {
    if (task.done == null && await _removeItemConfirm(task)) {
      await widget.db.deleteTodo(task.id);
      reloadFromDb();
    }
  }

  Future<bool> _removeItemConfirm(Todo task) {
    Completer<bool> completer = Completer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry?'),
          content: Text(task.title),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                completer.complete(false);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              onPressed: () {
                completer.complete(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BaseList(
      items: _tasks,
      openTitle: Text('TASKS'),
      doneTitle: Text('DONE'),
      valueStyle: TextStyle(color: Colors.redAccent),
      onAddItem: _showAddItemScreen,
      onDeleteItem: _removeItem,
      onToggleItem: _toggleItem,
    );
  }
}
