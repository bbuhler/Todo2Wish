import 'package:flutter/material.dart';
import 'package:todo2wish/models/DataProvider.dart';

class AccountButton extends StatefulWidget {
  AccountButton({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  AccountButtonState createState() => AccountButtonState();
}

class AccountButtonState extends State<AccountButton> {
  int _balance;

  void loadLogFromDb() async {
    await widget.db.fetchBalance();
  }

  @override
  void initState() {
    super.initState();
    widget.db.balance.addListener(() {
      setState(() {
        _balance = widget.db.balance.value;
      });
    });
    loadLogFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.stars,
          color: Theme.of(context).appBarTheme.actionsIconTheme.color),
      label: Text(
        _balance != null ? _balance.toString() : '',
        style: Theme.of(context).appBarTheme.textTheme.title,
      ),
      onPressed: () {}, // TODO show account overview
    );
  }
}
