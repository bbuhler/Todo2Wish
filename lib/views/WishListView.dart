import 'package:flutter/material.dart';
import 'package:objectdb/objectdb.dart';
import 'package:todo2wish/views/NewWishView.dart';

class WishList extends StatefulWidget {
  WishList({Key key, this.wishDB}) : super(key: key);

  final ObjectDB wishDB;

  @override
  WishListState createState() => WishListState();
}

class WishListState extends State<WishList> {
  List _wishes;

  void loadWishesFromDb() async {
    List wishes = await widget.wishDB.find({});
    setState(() {
      _wishes = wishes;
    });
  }

  @override
  void initState() {
    this.loadWishesFromDb();
    super.initState();
  }

//  @override
//  void dispose() async {
//    await widget.wishDB.close();
//    super.dispose();
//  }

  void _addWishItem(String wish) async {
    if (wish.length > 0) {
      await widget.wishDB.insert({'title': wish, 'price': 100, 'done': false});
      this.loadWishesFromDb();
    }
  }

  Widget _buildWishList() {
    if (this._wishes == null) {
      return Center(child: Text('Loading...'));
    } else {
      return ListView(
          children: this._wishes.map((wish) => _buildWishItem(wish)).toList());
    }
  }

  Widget _buildWishItem(Map wish) {
    print(wish);
    return ListTile(
      leading: wish['done']
          ? const Icon(Icons.check_box)
          : const Icon(Icons.check_box_outline_blank),
      title: Text(wish['title']),
      trailing: Text(
        wish['price'].toString(),
        style: TextStyle(color: Colors.green, fontSize: 16.0),
      ),
      onTap: () => _toggleWishItem(wish),
      onLongPress: () => _promptRemoveWishItem(wish),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddWishScreen,
        tooltip: 'Add wish',
        child: Icon(Icons.add),
      ),
      body: _buildWishList(),
    );
  }

  void _pushAddWishScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: NewWishView(
          onCreate: _addWishItem,
        ).build,
      ),
    );
  }

  void _removeWishItem(Map wish) async {
    await widget.wishDB.remove({'_id': wish['_id']});
    this.loadWishesFromDb();
  }

  void _toggleWishItem(Map wish) {
    widget.wishDB.update({'_id': wish['_id']}, {'done': !wish['done']});
    this.loadWishesFromDb();
  }

  void _promptRemoveWishItem(Map wish) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete entry "${wish['title']}"?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('DELETE'),
              onPressed: () {
                _removeWishItem(wish);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
