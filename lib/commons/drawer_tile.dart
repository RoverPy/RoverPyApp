import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isSelected;

  DrawerTile({this.iconData, this.title, this.isSelected});

  @override
  _DrawerTileState createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(widget.iconData, color: widget.isSelected?Theme.of(context).splashColor: Theme.of(context).primaryColor,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.title}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: widget.isSelected?Theme.of(context).splashColor: Theme.of(context).primaryColor,
                  fontWeight: widget.isSelected?FontWeight.w600:FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
    );
  }
}
