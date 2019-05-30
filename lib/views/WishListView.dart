import 'package:flutter/material.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/BaseList.dart';
import 'package:todo2wish/views/NewWishView.dart';

class WishList extends StatefulWidget {
  WishList({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  WishListState createState() => WishListState();
}

class WishListState extends State<WishList> {
  List<Todo> _wishes;

  void loadWishesFromDb() async {
    List wishes = await widget.db.getTodos(TodoType.wish);
    setState(() => _wishes = wishes);
  }

  @override
  void initState() {
    this.loadWishesFromDb();
    super.initState();
  }

  void _addWishItem(String wish) async {
    if (wish.length > 0) {
      Todo todo = Todo();
      todo.type = TodoType.wish;
      todo.title = wish;
      todo.value = -3;
      todo.since = DateTime.now();
      await widget.db.insertTodo(todo);
      this.loadWishesFromDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseList(
      items: _wishes,
      openTitle: Text('WISHES'),
      doneTitle: Text('DONE'),
      valueStyle: TextStyle(color: Colors.green, fontSize: 16.0),
      onAddItem: _pushAddWishScreen,
      onToggleItem: _toggleWishItem,
      onDeleteItem: _promptRemoveWishItem,
    );
  }

  void _pushAddWishScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: NewWishView(
          onCreate: _addWishItem,
        ).build,
      ),
    );
  }

  void _removeWishItem(Todo wish) async {
    await widget.db.deleteTodo(wish.id, TodoType.wish);
    this.loadWishesFromDb();
  }

  void _toggleWishItem(Todo wish) {
    if (wish.done == null) {
      wish.done = DateTime.now();
    } else {
      wish.done = null;
    }
    widget.db.updateTodo(wish);
    widget.db.fetchBalance();
    this.loadWishesFromDb();
  }

  void _promptRemoveWishItem(Todo wish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry "${wish.title}"?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('DELETE'),
              onPressed: () {
                _removeWishItem(wish);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
