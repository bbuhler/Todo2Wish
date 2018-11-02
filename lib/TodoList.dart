import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.title, this.todoDB}) : super(key: key);

  final String title;
  final ObjectDB todoDB;

  @override
  TodoListState createState() => new TodoListState();
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

  @override
  void dispose() async {
    await widget.todoDB.close();
    super.dispose();
  }

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
    return new ListTile(
      leading: task['done']
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: new Text(task['title']),
      trailing: new Text(task['value'].toString()),
      onTap: () => _toggleTodoItem(task),
      onLongPress: () => _promptRemoveTodoItem(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.stars, color: Colors.yellow),
            label: Text("152",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
          ),
        ],
//        bottom: TabBar(tabs: null), // TODO
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add a new task'),
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: new InputDecoration(
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
        return new AlertDialog(
          title: new Text('Delete entry "${task['title']}"?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text('DELETE'),
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
