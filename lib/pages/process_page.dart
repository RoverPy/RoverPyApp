import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in/models/user.dart';
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProcessingPage extends StatefulWidget {
  @override
  _ProcessingPageState createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  final _firestore = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  String _loaded;
  List<dynamic> _imgUrls;
  List<File> _images;
  List<List<Map>> _labels = [];
  String _currImg;

  Future<void> loadModel() async {
    final modelFile = await loadModelFromFirebase();
    _loaded =  await loadTFLiteModel(modelFile);
  }

  /// Downloads custom model from the Firebase console and return its file.
  /// located on the mobile device.
  static Future<File> loadModelFromFirebase() async {
    try {
      // Create model with a name that is specified in the Firebase console
      final model = FirebaseCustomRemoteModel('ChonkerLeaf');

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

  Future<void> getImages() async {
    DocumentSnapshot doc = await _firestore.collection('users').document(currUser.uid).get();
    _imgUrls = doc.data['urls'];
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<List<Map>> getImageLabels(File img) async {
    try {
      final image = img;
      if (image == null) {
        return null;
      }

      var labels = List<Map>.from(await Tflite.runModelOnImage(
        path: img.path,
        imageStd: 127.5,
        threshold: 0.8,
      ));
      print("label:");
      print(labels);
      return labels;
    } catch (exception) {
      print("Failed on getting your image and it's labels: $exception");
      print('Continuing with the program...');
      rethrow;
    }
  }

  processImages() {
    Future.forEach(_imgUrls, (element) async {
      File img = await urlToFile(element.toString());
      var lb = await getImageLabels(img);
      setState(() {
        _labels.add(lb);
        _currImg = element.toString();
      });
    });

  }

  loadStuff() async {
    await loadModel();
    await getImages();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Processing'),
      ),
      body: FutureBuilder(
        future: loadStuff(),
        builder: (context, snapshot) {
          if( snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else {
            if( _labels.length == 0)
              processImages();
            return Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(_currImg)),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}