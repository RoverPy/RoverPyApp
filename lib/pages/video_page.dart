// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sign_in/utils/themes.dart';
// import 'package:video_player/video_player.dart';

// class LiveFeed extends StatefulWidget {
//   @override
//   _LiveFeedState createState() => _LiveFeedState();
// }

// class _LiveFeedState extends State<LiveFeed> {
//   VideoPlayerController controller;
//   Future<void> initialisedController;

//   @override
//   void initState() {
//     controller = VideoPlayerController.network(
//         'http://192.168.10.37:8081/videostream.asf?user=&pwd=&resolution=64&rate=0');
//     initialisedController = controller.initialize();
//     controller.setVolume(1.0);
//     controller.play();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(gradient: Styles.background),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text('Live Feed'),
//         ),
//         body: FutureBuilder(
//           future: initialisedController,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done)
//               return AspectRatio(
//                 aspectRatio: controller.value.aspectRatio,
//                 child: VideoPlayer(controller),
//               );
//             else
//               return CircularProgressIndicator();
//           },
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           label: Text(controller.value.isPlaying ? 'Pause' : 'Play'),
//           icon:
//               Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
//           onPressed: () {
//             if (controller.value.isPlaying) {
//               setState(() {
//                 controller.pause();
//               });
//             } else {
//               setState(() {
//                 controller.play();
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class LiveFeed extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Rover Live Feed'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Mjpeg(
                isLive: isRunning.value,
                stream:
                    'http://192.168.10.37:8081/videostream.cgi?rate=0&user=&pwd=', //'http://192.168.1.37:8081',
              ),
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  isRunning.value = !isRunning.value;
                },
                child: Text('Toggle'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(),
                          )));
                },
                child: Text('Push new route'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
