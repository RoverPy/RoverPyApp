import 'package:flutter/material.dart';
import 'package:sign_in/models/developer_info.dart';

class Specific extends StatefulWidget {
  final DevInfo info;
  Specific({ this.info });
  @override
  _SpecificState createState() => _SpecificState();
}

class _SpecificState extends State<Specific> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Text("Miheer Chonk",
              style: TextStyle(
                fontSize: 20.0,
              ),
              ),
              Text(
                "This is a short description",
                style: TextStyle(
                  fontSize: 16.0,
                )
              )
            ],
          ),
          Container(
            height: 1/3 * MediaQuery.of(context).size.height,
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
            top: 50.0,

            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.info.imageLink),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }
}
