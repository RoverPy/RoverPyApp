import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class LiveFeed {

  Widget build(BuildContext context) {

    return Container(
      height: 200.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Mjpeg(
                isLive: true,
                stream:
                    'http://192.168.10.37:8081/videostream.cgi?rate=0&user=&pwd=', //'http://192.168.1.37:8081',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
