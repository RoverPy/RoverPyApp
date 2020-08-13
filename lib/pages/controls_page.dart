import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sign_in/commons/collapsing_navigation_drawer.dart';
import 'package:sign_in/commons/stepper_control.dart';
import 'package:sign_in/services/ChatPage.dart';
import 'package:sign_in/services/SelectBondedDevicePage.dart';
import 'package:sign_in/utils/utils_export.dart';
import '../services/ChatPage.dart';
import '../utils/customIcons.dart';

class ControlsPage extends StatefulWidget {
  final BluetoothDevice preSelectedServer;

  ControlsPage({this.preSelectedServer});

  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {

  ChatPage _chatPage = ChatPage(server: null,);
  BluetoothConnection connection;
  bool isDisconnecting = false;
  bool isConnecting = true;
  double stepperSize;

  bool get isConnected => connection != null && connection.isConnected;

  String prevChar = '';

  @override
  void initState() {
    super.initState();
    if( widget.preSelectedServer != null ){
      _chatPage = ChatPage(server: widget.preSelectedServer,);
    }
  }

  @override
  Widget build(BuildContext context) {

    stepperSize = (MediaQuery.of(context).size.height - (30.0+32.0+24.0)) / 3;

    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

    void onEndToggle(String char) {
      prevChar = char;
      if (_chatPage.server != null)
        _sendMessage(char);
    }

    void onToggle(String char) {
      if(prevChar == char)
        return;
      else {
        prevChar = char;
        if (_chatPage.server != null) {
          _sendMessage(char);
        } else {
          var snackBar = SnackBar(
            content: Text('Not connected to any device', style: Theme.of(context).textTheme.headline6,),
            duration: Duration(seconds: 1),
          );
          _key.currentState.showSnackBar(snackBar);
        }
      }
    }

    return Scaffold(
      key: _key,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: Styles.background,
        ),
        child: Column(
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("RoverPy Controls",
                            style: Theme.of(context).textTheme.headline3,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton<String>(
                            icon: Icon(CustomIcons.option, size: 12.0, color: Colors.white,),
                            itemBuilder: (context) {
                              return [PopupMenuItem(
                                child: Text('Connect to paired device to chat'),
                                value: 'connect to bluetooth',
                              )];
                            },
                            onSelected: (choice) => {connectMethod()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 15.0,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 5.0,
                            color: Theme.of(context).accentColor),
                      ]),
                      child: Card(
                        color: Theme.of(context).backgroundColor,
                        elevation: 5.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                                  child: Text(
                                    'Rover Controls',
                                    style: Theme.of(context).textTheme.headline6,
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
                                        size: stepperSize,
                                        direction: Axis.vertical,
                                        initialValue: 'S',
                                        positiveValue: 'F',
                                        negativeValue: 'B',
                                        onEnd: onEndToggle,
                                        onHoldDown: onToggle,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Center(
                                      child: StepperTouch(
                                        size: stepperSize,
                                        direction: Axis.horizontal,
                                        initialValue: 'S',
                                        positiveValue: 'L',
                                        negativeValue: 'R',
                                        onEnd: onEndToggle,
                                        onHoldDown: onToggle,
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 15.0,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 5.0, color: Theme
                          .of(context)
                          .accentColor),
                    ]),
                    child: Card(
                      color: Theme
                          .of(context)
                          .backgroundColor,
                      elevation: 5.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Belt Controls',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline6,
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
                                      size: stepperSize,
                                      direction: Axis.vertical,
                                      initialValue: 'S',
                                      positiveValue: 'H',
                                      negativeValue: 'J',
                                      onEnd: onEndToggle,
                                      onHoldDown: onToggle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Center(
                                    child: StepperTouch(
                                      size: stepperSize,
                                      direction: Axis.horizontal,
                                      initialValue: 'S',
                                      positiveValue: 'G',
                                      negativeValue: 'I',
                                      onEnd: onEndToggle,
                                      onHoldDown: onToggle,
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
                ],
              ),
      ),
      drawer: CollapsingNavDrawer(),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;
      } catch (e) {
        print('error: {e}');
      }
    }
  }

  void connectMethod() async {
    final BluetoothDevice selectedDevice =
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SelectBondedDevicePage(
              checkAvailability: false);
        },
      ),
    );
    _chatPage = ChatPage(
      server: selectedDevice,
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      //_startChat(context, selectedDevice);
    } else {
      print('Connect -> no device selected');
    }
    BluetoothConnection.toAddress(selectedDevice.address)
        .then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }
}
