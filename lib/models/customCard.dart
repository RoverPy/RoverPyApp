import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final String url = "https://github.com";
  CustomCard({ this.name });
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){},
        splashColor: Colors.amberAccent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1552058544-f2b08422138a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
            ),
            title: Text(widget.name),
            trailing: InkWell(
              onTap: (){
                launch(widget.url);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
              ),
            )
          ),
        ),
      ),
    );
  }
}
