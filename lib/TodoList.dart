import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.todoDB}) : super(key: key);

  final ObjectDB todoDB;

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List _tasks;

  void loadTasksFromDb() async {
    List tasks = await widget.todoDB.find({});
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
      await widget.todoDB.insert({'title': task, 'value': 0, 'done': false});
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

  Widget _buildTodoItem(Map task) {
    print(task);
    return ListTile(
      leading: task['done']
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(task['title']),
      trailing: Text(task['value'].toString()),
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
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add a task'),
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }

  void _removeTodoItem(Map task) async {
    await widget.todoDB.remove({'_id': task['_id']});
    this.loadTasksFromDb();
  }

  void _toggleTodoItem(Map task) {
    widget.todoDB.update({'_id': task['_id']}, {'done': !task['done']});
    this.loadTasksFromDb();
  }

  void _promptRemoveTodoItem(Map task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry "${task['title']}"?'),
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
