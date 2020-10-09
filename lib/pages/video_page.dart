import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in/utils/themes.dart';
import 'package:video_player/video_player.dart';

class LiveFeed extends StatefulWidget {
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  VideoPlayerController controller;
  Future<void> initialisedController;

  @override
  void initState() {
    controller = VideoPlayerController.network('https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4');
    initialisedController = controller.initialize();
    controller.setVolume(1.0);
    controller.play();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Styles.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Live Feed'),
        ),
        body: FutureBuilder(
          future: initialisedController,
          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              );
            else
              return CircularProgressIndicator();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(controller.value.isPlaying? 'Pause': 'Play'),
          icon: Icon(controller.value.isPlaying? Icons.pause: Icons.play_arrow),
          onPressed: () {
            if(controller.value.isPlaying) {
              setState(() {
                controller.pause();
              });
            }
            else {
              setState(() {
                controller.play();
              });
            }
          },
        ),
      ),
    );
  }
}
