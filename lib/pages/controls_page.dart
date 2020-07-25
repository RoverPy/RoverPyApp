import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sign_in/commons/collapsing_navigation_drawer.dart';
import 'package:sign_in/commons/stepper_control.dart';
import 'package:sign_in/services/ChatPage.dart';
import 'package:sign_in/services/SelectBondedDevicePage.dart';

class ControlsPage extends StatefulWidget {
  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  ChatPage _chatPage;
  BluetoothConnection connection;
  bool isDisconnecting = false;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

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
      body: Builder(
        builder: (context) {
          if (MediaQuery.of(context).size.height >
              MediaQuery.of(context).size.width)
            return Column(
              children: <Widget>[
                RaisedButton(
                  child: const Text('Connect to paired device to chat'),
                  onPressed: () async {
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
                    // if (selectedDevice != null) {
                    //   print('Connect -> selected ' + selectedDevice.address);
                    //   _startChat(context, selectedDevice);
                    // } else {
                    //   print('Connect -> no device selected');
                    // }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2 - 60.0,
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 8.0, 8.0, 8.0),
                                child: Container(
                                  child: Center(
                                    child: StepperTouch(
                                      size: 200.0,
                                      direction: Axis.vertical,
                                      initialValue: 'S',
                                      positiveValue: 'F',
                                      negativeValue: 'B',
                                      onEnd: (String value) {
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
                                      },
                                      onHoldDown: (String value) {
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
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
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
                                      },
                                      onHoldDown: (String value) {
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
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
                  height: MediaQuery.of(context).size.height / 2 - 100.0,
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
                            size: 200.0,
                            direction: Axis.vertical,
                            initialValue: 'S',
                            positiveValue: 'U',
                            negativeValue: 'D',
                            onEnd: (String value) {
                              if (_chatPage.server != null) {
                                print('Connect -> selected ' +
                                    _chatPage.server.address);
                                _sendMessage(value);
                              } else {
                                print('Connect -> no device selected');
                              }
                            },
                            onHoldDown: (String value) {
                              if (_chatPage.server != null) {
                                print('Connect -> selected ' +
                                    _chatPage.server.address);
                                _sendMessage(value);
                              } else {
                                print('Connect -> no device selected');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          else
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2 - 10.0,
                    width: MediaQuery.of(context).size.height - 15.0,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 5.0,
                          color: Theme.of(context).accentColor),
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
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
                                      },
                                      onHoldDown: (String value) {
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
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
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
                                      },
                                      onHoldDown: (String value) {
                                        if (_chatPage.server != null) {
                                          print('Connect -> selected ' +
                                              _chatPage.server.address);
                                          _sendMessage(value);
                                        } else {
                                          print(
                                              'Connect -> no device selected');
                                        }
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
                  height: MediaQuery.of(context).size.width / 2 - 10.0,
                  width: MediaQuery.of(context).size.height - 15.0,
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
                              if (_chatPage.server != null) {
                                print('Connect -> selected ' +
                                    _chatPage.server.address);
                                _sendMessage(value);
                              } else {
                                print('Connect -> no device selected');
                              }
                            },
                            onHoldDown: (String value) {
                              if (_chatPage.server != null) {
                                print('Connect -> selected ' +
                                    _chatPage.server.address);
                                _sendMessage(value);
                              } else {
                                print('Connect -> no device selected');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  child: const Text('Connect to paired device to chat'),
                  onPressed: () async {
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
                    // if (selectedDevice != null) {
                    //   print('Connect -> selected ' + selectedDevice.address);
                    //   _startChat(context, selectedDevice);
                    // } else {
                    //   print('Connect -> no device selected');
                    // }
                  },
                ),
              ],
            );
        },
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
}
