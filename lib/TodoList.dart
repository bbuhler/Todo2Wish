import 'package:flutter/material.dart';
import 'package:todo2wish/main.dart';

class TodoItem {
  String title;
  int value;
  bool done;

  TodoItem(this.title, [this.value = 0, this.done = false]);
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<TodoItem> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(new TodoItem(task)));
    }
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  Widget _buildTodoItem(TodoItem item, int index) {
    return new ListTile(
      leading: item.done
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: new Text(item.title),
      trailing: new Text(item.value.toString()),
      onTap: () => _toggleTodoItem(item),
      onLongPress: () => _promptRemoveTodoItem(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(APP_TITLE),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.stars, color: Colors.yellow),
            label: Text("152", style: TextStyle
            (
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

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _toggleTodoItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
    });
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Delete entry "${_todoItems[index].title}"?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text('DELETE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
