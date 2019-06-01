import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo2wish/models/DataProvider.dart';
import 'package:todo2wish/views/BaseList.dart';
import 'package:todo2wish/views/NewWishView.dart';

import '../Localizations.dart';

class WishList extends StatefulWidget {
  WishList({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  WishListState createState() => WishListState();
}

class WishListState extends State<WishList> {
  List<Todo> _wishes;

  void reloadFromDb() async {
    List<Todo> wishes = await widget.db.getTodos(TodoType.wish);
    setState(() => _wishes = wishes);
  }

  @override
  void initState() {
    reloadFromDb();
    super.initState();
  }

  void _showAddItemScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: NewWishView(
          onCreate: _addItem,
        ).build,
      ),
    );
  }

  void _addItem(String wish, int value) async {
    if (wish.length > 0 && value != null) {
      Todo todo = Todo();
      todo.type = TodoType.wish;
      todo.title = wish;
      todo.value = value * -1;
      todo.since = DateTime.now();
      await widget.db.insertTodo(todo);
      reloadFromDb();
    }
  }

  Future<bool> _isToggleDoneAllowed(Todo wish) async {
    return wish.done == null &&
        widget.db.balance.value >= wish.value.abs() &&
        await _toggleItemConfirm(
          wish,
          MainLocalizations.of(context).wishesConfirmFulfill(wish.title),
          MainLocalizations.of(context).actionFulfill,
        );
  }

  Future<bool> _isToggleUndoneAllowed(Todo wish) async {
    return wish.done != null &&
        await _toggleItemConfirm(
          wish,
          MainLocalizations.of(context).wishesConfirmUnfulfilled(wish.title),
          MainLocalizations.of(context).actionUnfulfilled,
        );
  }

  Future _toggleItem(Todo wish) async {
    if (await _isToggleDoneAllowed(wish)) {
      wish.done = DateTime.now();
      widget.db.updateTodo(wish);
    } else if (await _isToggleUndoneAllowed(wish)) {
      wish.done = null;
      widget.db.updateTodo(wish);
    }

    widget.db.fetchBalance();
    reloadFromDb();
  }

  Future<bool> _toggleItemConfirm(Todo wish, String title, String action) {
    Completer<bool> completer = Completer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text(MainLocalizations.of(context).actionCancel),
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

  void _removeItem(Todo wish) async {
    if (wish.done == null && await _removeItemConfirm(wish)) {
      await widget.db.deleteTodo(wish.id, TodoType.wish);
      this.reloadFromDb();
    }
  }

  Future<bool> _removeItemConfirm(Todo wish) async {
    Completer<bool> completer = Completer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              MainLocalizations.of(context).wishesConfirmDelete(wish.title)),
          actions: <Widget>[
            FlatButton(
              child: Text(MainLocalizations.of(context).actionCancel),
              onPressed: () {
                completer.complete(false);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(MainLocalizations.of(context).actionDelete),
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
      items: _wishes,
      openTitle: MainLocalizations.of(context).wishesTitle,
      doneTitle: MainLocalizations.of(context).wishesFulfilled,
      valueStyle: TextStyle(color: Colors.green, fontSize: 16.0),
      onAddItem: _showAddItemScreen,
      onToggleItem: _toggleItem,
      onDeleteItem: _removeItem,
    );
  }
}
