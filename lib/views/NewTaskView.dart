import 'package:flutter/material.dart';

class NewTaskView extends StatelessWidget {
  NewTaskView({Key key, this.onCreate}) : super(key: key);

  final Function onCreate;
  final taskTitleCtrl = TextEditingController();
  final sinceDateCtrl = TextEditingController();

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
                onCreate(taskTitleCtrl.text, sinceDateCtrl.text);
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
              style: TextStyle(
                fontSize: 24.0,
                color: bottomAppBarColor,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.check_box_outline_blank,
                  color: bottomAppBarColor,
                ),
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
              controller: sinceDateCtrl,
              keyboardType: TextInputType.datetime,
              onTap: () async {
                DateTime selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 15),
                  lastDate: DateTime.now(),
                );
                sinceDateCtrl.text = "${selectedDate.year.toString()}" +
                    "-${selectedDate.month.toString().padLeft(2, '0')}" +
                    "-${selectedDate.day.toString().padLeft(2, '0')}";
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.today),
                contentPadding: const EdgeInsets.all(16.0),
                hintText: 'Creation date',
                border: InputBorder.none,
              ),
            ),
          ]),
        ));
  }
}
