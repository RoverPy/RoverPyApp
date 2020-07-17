import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in/commons/collapsing_navigation_drawer.dart';
import 'package:sign_in/commons/stepper_control.dart';

class ControlsPage extends StatefulWidget {
  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'RoverPy Controls',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 15.0,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0, color: Theme.of(context).accentColor),
                ]),
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  elevation: 5.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Rover Controls',
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                child: StepperTouch(
                                  size: 220.0,
                                  direction: Axis.vertical,
                                  initialValue: 'S',
                                  positiveValue: 'F',
                                  negativeValue: 'B',
                                  onEnd: (String value) {
                                    print(
                                        value); //TODO: Replace with Bluetooth function
                                  },
                                  onHoldDown: (String value) {
                                    print(
                                        value); //TODO: Replace with Bluetooth function
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                child: StepperTouch(
                                  size: 220.0,
                                  direction: Axis.horizontal,
                                  initialValue: 'S',
                                  positiveValue: 'L',
                                  negativeValue: 'R',
                                  onEnd: (String value) {
                                    print(
                                        value); //TODO: Replace with Bluetooth function
                                  },
                                  onHoldDown: (String value) {
                                    print(
                                        value); //TODO: Replace with Bluetooth function
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 15.0,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 5.0, color: Theme.of(context).accentColor),
              ]),
              child: Card(
                elevation: 5.0,
                color: Theme.of(context).backgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Belt Controls',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StepperTouch(
                        size: 220.0,
                        direction: Axis.vertical,
                        initialValue: 'S',
                        positiveValue: 'U',
                        negativeValue: 'D',
                        onEnd: (String value) {
                          print(value); //TODO: Replace with Bluetooth function
                        },
                        onHoldDown: (String value) {
                          print(value); //TODO: Replace with Bluetooth function
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: CollapsingNavDrawer(),
    );
  }
}
