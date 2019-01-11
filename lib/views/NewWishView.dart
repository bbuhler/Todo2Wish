import 'package:flutter/material.dart';

class NewWishView extends StatelessWidget {
  NewWishView({Key key, this.onCreate}) : super(key: key);

  final Function onCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a wish'),
      ),
      body: TextField(
        // TODO use a Form
        // TODO add icon before
        // TODO floating label?
        // TODO Add price category
        autofocus: true,
        onSubmitted: (val) {
          onCreate(val);
          Navigator.pop(context);
        },
        decoration: InputDecoration(
          hintText: 'Enter a wish...',
          contentPadding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
