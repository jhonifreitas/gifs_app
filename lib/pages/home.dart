import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:gifs_app/pages/detail.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:gifs_app/services/api.dart' as api;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              onSubmitted: (value){
                setState(() {
                  this._search = value;
                  this._offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: this._search == null ? api.getAll(this._offset) : api.getSearch(this._search, this._offset),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return this.buildLoading();
                  default:
                    if(snapshot.hasError) return this.buildError();
                    else return this.buildGrid(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildGrid(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10
      ),
      itemCount: snapshot.data.length + 1,
      itemBuilder: (context, index){
        if(index < snapshot.data.length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data[index]['images']['fixed_height']['url'],
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
              );
            },
            onLongPress: () => Share.share(snapshot.data[index]['images']['fixed_height']['url']),
          );
        else
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.white, size: 70),
                Text('Carregar mais...', style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: (){
              setState((){
                this._offset += 19;
              });
            },
          );
      },
    );
  }

  Widget buildLoading(){
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget buildError(){
    return Center(
      child: Text('Ops! Não foi possivel carregar. Verifique sua conexão de rede.'),
    );
  }
}
