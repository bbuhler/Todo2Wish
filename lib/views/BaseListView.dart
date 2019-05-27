import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BaseList extends StatefulWidget {
  final VoidCallback onAddItem;
  final List<Widget> openItems;
  final List<Widget> doneItems;
  final Text openTitle;
  final Text doneTitle;

  BaseList({
    Key key,
    this.onAddItem,
    this.openTitle,
    this.doneTitle,
    this.openItems,
    this.doneItems,
  }) : super(key: key);

  @override
  BaseListState createState() => BaseListState();
}

class BaseListState extends State<BaseList> {
  bool _floatingBtnVisible = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      switch (scrollController.position.userScrollDirection) {
        case ScrollDirection.reverse:
          setState(() => _floatingBtnVisible = false);
          break;

        case ScrollDirection.forward:
          setState(() => _floatingBtnVisible = true);
          break;

        default:
      }
    });
  }

  _floatingButton() {
    return _floatingBtnVisible
        ? FloatingActionButton(
            onPressed: widget.onAddItem,
            child: Icon(Icons.add),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingButton(),
      body: ListView(
        controller: scrollController,
        children: [
          ExpansionTile(
            title: widget.openTitle,
            initiallyExpanded: true,
            children: widget.openItems,
          ),
          ExpansionTile(
            title: widget.doneTitle,
            initiallyExpanded: true,
            children: widget.doneItems,
          ),
        ],
      ),
    );
  }
}
