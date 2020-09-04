import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final String image;
  final String url;
  final String subtitle;
  CustomCard({ this.name, this.image, this.url, this.subtitle});
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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.image),
          ),
          title: Text(widget.name),
          trailing: InkWell(
            onTap: (){
              launch(widget.url);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: AssetImage('assets/github_logo.png'),
            ),
          )
        ),
      ),
    );
  }
}
