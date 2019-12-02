import 'package:flutter/material.dart';

class Article extends StatefulWidget {
  String title;
  String image;
  String article;
  Article(@required this.title, @required this.image,@required this.article);
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return<Widget> [
            SliverAppBar(
            expandedHeight: 250,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: innerBoxIsScrolled ? Text('Maxiga'):Text(''),
              background: Image.network(widget.image, fit: BoxFit.cover,),
            ),
            actions: <Widget>[
              FlatButton(
                child: Icon(Icons.open_in_browser, color: Colors.white,),
                onPressed: (){
                  print(widget.article);
                },
              )
            ],
          )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container( child: Text(widget.title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)),
                Container(child: Text(widget.article,textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,maxLines: 1000,))
              ],
            ),
          ),
        )
      )
    );
  }
}