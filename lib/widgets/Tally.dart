import 'package:flutter/material.dart';

class Tally extends StatelessWidget {
  Tally(this.count, {Key key}) : super(key: key);

  final int count;
  final int strikeEvery = 5;

  @override
  Widget build(BuildContext context) {
    int blockCount = (count / strikeEvery).ceil();
    int restCount = count % strikeEvery;

    List<Widget> blocks =
        new List.generate(blockCount, (i) => _blockOf(strikeEvery));

    if (restCount > 0) {
      blocks.add(_blockOf(restCount));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: blocks,
    );
  }

  _blockOf(int lines) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0),
        child: Container(
          child: Text(
            'I' * (lines == strikeEvery ? strikeEvery - 1 : lines),
            style: TextStyle(
                color: Colors.redAccent, fontSize: 20.0, letterSpacing: -1.0),
          ),
          decoration: lines < strikeEvery
              ? null
              : BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.9, -1.0),
                    end: Alignment(0.9, 1.0),
                    stops: [0.0, 0.45, 0.50, 0.55, 1.0],
                    colors: <Color>[
                      Colors.white,
                      Colors.white,
                      Colors.redAccent,
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
        ));
  }
}
