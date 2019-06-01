import 'package:flutter/material.dart';

import '../Localizations.dart';

class NewWishView extends StatelessWidget {
  NewWishView({Key key, this.onCreate}) : super(key: key);

  final Function onCreate;
  final wishTitleCtrl = TextEditingController();
  final wishValueCtrl = TextEditingController();

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = int.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid integer';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Color bottomAppBarColor = Theme.of(context).bottomAppBarColor;

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check, color: bottomAppBarColor),
              onPressed: () {
                onCreate(wishTitleCtrl.text, int.tryParse(wishValueCtrl.text));
                Navigator.pop(context);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: TextField(
              autofocus: true,
              cursorColor: bottomAppBarColor,
              controller: wishTitleCtrl,
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
                hintText: MainLocalizations.of(context).wishesNewTitleHint,
                hintStyle: TextStyle(color: bottomAppBarColor.withOpacity(.75)),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(children: <Widget>[
            TextFormField(
              controller: wishValueCtrl,
              keyboardType: TextInputType.number,
              validator: numberValidator,
              inputFormatters: [],
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.stars),
                contentPadding: const EdgeInsets.all(16.0),
                hintText: MainLocalizations.of(context).wishesNewValueHint,
                border: InputBorder.none,
              ),
            ),
          ]),
        ));
  }
}
