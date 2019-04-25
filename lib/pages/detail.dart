import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DetailPage extends StatelessWidget {

  final Map _data;

  DetailPage(this._data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._data['title']),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(this._data['images']['fixed_height']['url']);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(this._data['images']['fixed_height']['url']),
      ),
    );
  }
}
