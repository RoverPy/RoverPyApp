import 'package:flutter/material.dart';
import 'package:sign_in/commons/collapsing_navigation_drawer.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Reports',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: Container(),
      drawer: CollapsingNavDrawer(),
    );
  }
}
