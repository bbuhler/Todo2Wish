import 'package:flutter/material.dart';

class NewTaskView extends StatelessWidget {
  NewTaskView({Key key, this.onCreate}) : super(key: key);

  final Function onCreate;
  final taskTitleCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color bottomAppBarColor = Theme.of(context).bottomAppBarColor;

    // TODO use a Form (https://flutter.io/docs/cookbook/forms/validation)
    // TODO use floating labels?
    // TODO reminder field? (https://github.com/serralvo/schedule_notifications)

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check, color: bottomAppBarColor),
              onPressed: () {
                onCreate(taskTitleCtrl.text);
                Navigator.pop(context);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: TextField(
              autofocus: true,
              cursorColor: bottomAppBarColor,
              controller: taskTitleCtrl,
              style: TextStyle(fontSize: 24.0),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.check_box_outline_blank,
                    color: bottomAppBarColor),
                contentPadding: const EdgeInsets.all(20.0),
                hintText: 'Enter a task...',
                hintStyle: TextStyle(color: bottomAppBarColor.withOpacity(.75)),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(children: <Widget>[
            TextField(
              // TODO replace with DatePicker
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.today),
                contentPadding: const EdgeInsets.all(16.0),
                hintText: 'Creation date',
                border: InputBorder.none,
              ),
            ),
            TextField(
              // TODO replace with DatePicker
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.timer),
                contentPadding: const EdgeInsets.all(16.0),
                hintText: 'Due date',
                border: InputBorder.none,
              ),
            ),
            TextField(
              // TODO replace with Dropdown
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.sort),
                contentPadding: const EdgeInsets.all(16.0),
                hintText: 'Priority',
                border: InputBorder.none,
              ),
            ),
          ]),
        ));
  }
}
