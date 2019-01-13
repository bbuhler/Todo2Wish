import 'package:flutter/material.dart';
import 'package:todo2wish/models/DataProvider.dart';

class AccountButton extends StatefulWidget {
  AccountButton({Key key, this.db}) : super(key: key);

  final DataProvider db;

  @override
  AccountButtonState createState() => AccountButtonState();
}

class AccountButtonState extends State<AccountButton> {
  int _balance = 0;

  void loadLogFromDb() async {
    int balance = await widget.db.getBalance();

    setState(() {
      _balance = balance;
    });
  }

  @override
  void initState() {
    this.loadLogFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.stars, color: Colors.yellow),
      label: Text(
        _balance.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      onPressed: () {}, // TODO show account overview
    );
  }
}
