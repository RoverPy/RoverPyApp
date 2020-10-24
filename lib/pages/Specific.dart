import 'package:flutter/material.dart';
import 'package:sign_in/models/developer_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Specific extends StatefulWidget {
  final DevInfo info;
  final int i;
  final String url;
  Specific({this.info, this.i, this.url});
  @override
  _SpecificState createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  List<Color> colorList = [
    new Color(0xffff5f6d),
    new Color(0xffffc371),
    new Color(0xff43cea2),
    new Color(0xff185a9d),
    new Color(0xff4568dc),
    new Color(0xffb06ab3),
    new Color(0xffeecda3),
    new Color(0xffef629f)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Color(0xff333333),
      body: Stack(
        // alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1 / 3 * MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [colorList[2*(widget.i)], colorList[2*(widget.i)+1]],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
          ),
          Positioned(
            top: 1 / 3 * MediaQuery.of(context).size.height - 41.5,
            left: 1 / 2 * MediaQuery.of(context).size.width - 41.5,
            child: Hero(
              tag: "Profile${widget.i}",
              child: Material(
                type: MaterialType.transparency,
                child: CircleAvatar(
                  backgroundImage: AssetImage(widget.info.imageLink),
                  radius: 45.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Hero(
                  tag: "Name${widget.i}",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.info.name,
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(widget.info.otherInfo.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: new Color(0xffff958d),
                    )),
              ]),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        onPressed: () {
          launch(widget.url);
        },
        tooltip: "Github",
        child: Icon(Icons.code),
      ),
    );
  }
}
