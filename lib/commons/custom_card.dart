import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final String image;
  final String url;
  final String subtitle;
  final int i;
  CustomCard({ this.name, this.image, this.url, this.subtitle, this.i});
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        child: ListTile(
          leading: Hero(
            tag: "Profile${widget.i}",
            child: Material(
              type: MaterialType.transparency,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
                radius: 20.0,
              ),
            ),
          ),
          title: Hero(
            tag: "Name${widget.i}",
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                    widget.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              )
          ),
          trailing: InkWell(
            onTap: (){
              launch(widget.url);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: AssetImage('assets/github_logo.png'),
              radius: 15.0,
            ),
          )
        ),
      ),
    );
  }
}
