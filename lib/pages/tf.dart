import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:math';
import 'package:image/image.dart' as img;

class Tf extends StatefulWidget {
  @override
  _TfState createState() => _TfState();
}

class _TfState extends State<Tf> {
  final ImagePicker _picker = ImagePicker();
  File _image;
  List<Map<dynamic, dynamic>> _labels;
  //When the model is ready, _loaded changes to trigger the screen state change.
  Future<String> _loaded = loadModel();

  /// Triggers selection of an image and the consequent inference.
  Future<void> getImageLabels() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      final image = File(pickedFile.path);
      if (image == null) {
        return;
      }

      var labels = List<Map>.from(await Tflite.runModelOnImage(
        path: image.path,
        imageStd: 127.5,
        threshold: 0.69,
      ));
      print("label:");
      print(labels);
      setState(() {
        _labels = labels;
        _image = image;
      });
    } catch (exception) {
      print("Failed on getting your image and it's labels: $exception");
      print('Continuing with the program...');
      rethrow;
    }
  }

  /// Gets the model ready for inference on images.
  static Future<String> loadModel() async {
    final modelFile = await loadModelFromFirebase();
    return await loadTFLiteModel(modelFile);
  }

  /// Downloads custom model from the Firebase console and return its file.
  /// located on the mobile device.
  static Future<File> loadModelFromFirebase() async {
    try {
      // Create model with a name that is specified in the Firebase console
      final model = FirebaseCustomRemoteModel('BetaTesting');

      // Specify conditions when the model can be downloaded.
      // If there is no wifi access when the app is started,
      // this app will continue loading until the conditions are satisfied.
      final conditions = FirebaseModelDownloadConditions(
        androidRequireWifi: true,
        iosAllowCellularAccess: false,
        iosAllowBackgroundDownloading: true,
        androidRequireDeviceIdle: false,
      );

      // Create model manager associated with default Firebase App instance.
      final modelManager = FirebaseModelManager.instance;

      // Begin downloading and wait until the model is downloaded successfully.
      await modelManager.download(model, conditions);
      assert(await modelManager.isModelDownloaded(model) == true);

      // Get latest model file to use it for inference by the interpreter.
      var modelFile = await modelManager.getLatestModelFile(model);
      assert(modelFile != null);
      return modelFile;
    } catch (exception) {
      print('Failed on loading your model from Firebase: $exception');
      print('The program will not be resumed');
      rethrow;
    }
  }

  /// Loads the model into some TF Lite interpreter.
  /// In this case interpreter provided by tflite plugin.
  static Future<String> loadTFLiteModel(File modelFile) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();
      final labelsData = await rootBundle.load("assets/labels.txt");
      final labelsFile = await File(appDirectory.path + "/labels.txt")
          .writeAsBytes(labelsData.buffer
              .asUint8List(labelsData.offsetInBytes, labelsData.lengthInBytes));

      assert(await Tflite.loadModel(
            model: modelFile.path,
            labels: labelsFile.path,
            isAsset: false,
          ) ==
          "success");
      return "Model is loaded";
    } catch (exception) {
      print(
          'Failed on loading your model to the TFLite interpreter: $exception');
      print('The program will not be resumed');
      rethrow;
    }
  }

  /// Shows image selection screen only when the model is ready to be used.
  Widget readyScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase ML Custom example app'),
      ),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image)
              : Text('Please select image to analyze.'),
          Column(
            children: _labels != null
                ? _labels.map((label) {
                    return Text(
                      "${label["label"]}",
                      style: TextStyle(color: Colors.black),
                    );
                  }).toList()
                : [],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageLabels,
        child: Icon(Icons.add),
      ),
    );
  }

  /// In case of error shows unrecoverable error screen.
  Widget errorScreen() {
    return Scaffold(
      body: Center(
        child: Text("Error loading model. Please check the logs."),
      ),
    );
  }

  /// In case of long loading shows loading screen until model is ready or
  /// error is received.
  Widget loadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CircularProgressIndicator(),
            ),
            Text(
              "Please make sure that you are using wifi.",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows different screens based on the state of the custom model.
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _loaded, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return readyScreen();
          } else if (snapshot.hasError) {
            return errorScreen();
          } else {
            return loadingScreen();
          }
        },
      ),
    );
  }
}
