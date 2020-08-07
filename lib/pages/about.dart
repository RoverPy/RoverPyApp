import 'package:flutter/material.dart';
import 'package:sign_in/models/customCard.dart';


import 'package:sign_in/models/customCard.dart';class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomCard(),
          ],
        ),
      ),
    );
  }
}
