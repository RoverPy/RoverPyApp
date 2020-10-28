import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sign_in/pages/controls_page.dart';
import 'package:sign_in/pages/tf.dart';
import 'package:sign_in/services/ChatPage.dart';
import 'package:sign_in/services/SelectBondedDevicePage.dart';
import 'package:sign_in/utils/utils_export.dart';
import 'dart:math';
import 'package:sign_in/services/AuthService.dart';

import '../utils/themes.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _HomePageState extends State<HomePage> {
  var currentPage = images.length - 1.0;
  BluetoothDevice _device;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(gradient: Styles.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("RoverPy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontFamily: "Calibre-Semibold",
                          letterSpacing: 1.0,
                        )),
                    PopupMenuButton<String>(
                        icon: Icon(
                          CustomIcons.option,
                          size: 12.0,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text('Logout'),
                              value: '0',
                            )
                          ];
                        },
                        onSelected: (value) {
                          AuthService obj = AuthService();
                          obj.logOut();
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFff6e6e),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(22.0, 10.0, 22.0, 6.0),
                          child: Text("Profile Name",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            int i = currentPage.round();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => pushTo[i]));
                          },
                            child: Container());
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Rover Connect",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontFamily: "Calibre-Semibold",
                          letterSpacing: 1.0,
                        )),
                    IconButton(
                      icon: Icon(
                        CustomIcons.option,
                        size: 12.0,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: connectMethod,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(22.0, 10.0, 22.0, 6.0),
                            child: Text("Quick Connect",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ControlsPage(preSelectedServer: _device,)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/controller.jpg",
                            width: 296.0, height: 222.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).pop();
          },
          heroTag: 'fab',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          elevation: 5.0,
          tooltip: "Go back",
          child: Icon(Icons.code),
        ),
      ),
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

  void connectMethod() async {
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SelectBondedDevicePage(checkAvailability: false);
        },
      ),
    );
    ChatPage _chatPage = ChatPage(
      server: selectedDevice,
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      _device = selectedDevice;
    } else {
      print('Connect -> no device selected');
    }
    BluetoothConnection.toAddress(selectedDevice.address).then((_connection) {
      print('Connected to the device');
      BluetoothConnection connection = _connection;
      var isDisconnecting = false;

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

class CardScrollWidget extends StatelessWidget {
  final currentPage;
  final padding = 20.0;
  final verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(images[i], fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter,
                              colors: [Colors.black45, Colors.transparent],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(title[i],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child:Container(
                                padding: EdgeInsets.fromLTRB(22.0, 10.0, 22.0, 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                  child: Text("View",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
