import 'package:flutter/material.dart';
import 'package:sign_in/models/developer_info.dart';

class Specific extends StatefulWidget {
  final DevInfo info;
  Specific({this.info});
  @override
  _SpecificState createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        // alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1 / 3 * MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.teal],
                stops: [0.0, 0.7],
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
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.info.imageLink),
              radius: 45.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  widget.info.name,
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
                Text("This is a short description",
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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
