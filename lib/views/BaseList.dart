import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo2wish/models/DataProvider.dart';

class BaseList extends StatefulWidget {
  final List<Todo> items;
  final VoidCallback onAddItem;
  final Function onDeleteItem;
  final Function onToggleItem;
  final String openTitle;
  final String doneTitle;
  final TextStyle valueStyle;

  BaseList({
    Key key,
    this.items,
    this.onAddItem,
    this.onDeleteItem,
    this.onToggleItem,
    this.openTitle,
    this.doneTitle,
    this.valueStyle,
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

  Widget _floatingButton() {
    return _floatingBtnVisible
        ? FloatingActionButton(
            onPressed: widget.onAddItem,
            child: Icon(Icons.add),
          )
        : Container();
  }

  Widget _buildItem(Todo item) {
    return ListTile(
      leading: item.done != null
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(item.title),
      trailing: item.value == 0
          ? null
          : Text(
              item.value.abs().toString(),
              style: widget.valueStyle,
            ),
      onTap: () => widget.onToggleItem(item),
      onLongPress: () => widget.onDeleteItem(item),
    );
  }

  Widget _buildExpansionTile(String title, List<Widget> items) {
    return items.length > 0
        ? ExpansionTile(
            title: Text(title
                .toUpperCase()), // TODO replace uppercase with with TextStyle as soon it's supported
            initiallyExpanded: true,
            children: items,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingButton(),
      body: widget.items == null
          ? Center(child: Text('Loading...'))
          : ListView(
              controller: scrollController,
              children: [
                _buildExpansionTile(
                    widget.openTitle,
                    widget.items
                        .where((item) => item.done == null)
                        .map(_buildItem)
                        .toList()),
                _buildExpansionTile(
                    widget.doneTitle,
                    widget.items
                        .where((item) => item.done != null)
                        .map(_buildItem)
                        .toList()),
              ].where((Object o) => o != null).toList(),
            ),
    );
  }
}
