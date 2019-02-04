import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _floatingBtnVisible = true;
  ScrollController _hideFloatingBtnController = ScrollController();

  void loadTasksFromDb() async {
    List<Todo> tasks = await widget.db.getTodos();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  void initState() {
    loadTasksFromDb();
    super.initState();
    _hideFloatingBtnController.addListener(() {
      switch (_hideFloatingBtnController.position.userScrollDirection) {
        case ScrollDirection.reverse:
          setState(() {
            _floatingBtnVisible = false;
          });
          break;

        case ScrollDirection.forward:
          setState(() {
            _floatingBtnVisible = true;
          });
          break;

        default:
      }
    });
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

  Widget _buildTodoList() {
    if (_tasks == null) {
      return Center(child: Text('Loading...'));
    } else {
      return ListView.separated(
        controller: _hideFloatingBtnController,
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildTodoItem(_tasks[index]),
        separatorBuilder: (BuildContext context, int index) =>
            _buildSeparator(_tasks[index], _tasks[index + 1]),
      );
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

  Widget _buildSeparator(Todo currTask, Todo nextTask) {
    if (currTask.done == null && nextTask.done != null) {
      return ListTile(
        title: Text('DONE', style: TextStyle(color: Colors.grey)),
      );
    }

    // TODO find a better solution than invisible divider
    return Divider(height: 0.0, color: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Opacity(
        opacity: _floatingBtnVisible ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: Icon(Icons.add),
        ),
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
