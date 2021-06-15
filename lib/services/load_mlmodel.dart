import 'dart:io';

import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:tflite/tflite.dart';

class LoadMlModel {
  static Future<String> loadModel() async {
    print('checking is it on cloud!!!!');
    final modelFile = await loadModelFromFirebase();
    return await loadTFLiteModel(modelFile);
  }

  /// Downloads custom model from the Firebase console and return its file.
  /// located on the mobile device.
  static Future<File> loadModelFromFirebase() async {
    try {
      // Create model with a name that is specified in the Firebase console
      // final model = FirebaseCustomRemoteModel('DogCat');
      final model = FirebaseCustomRemoteModel('BLRBER-ml');

      // Specify conditions when the model can be downloaded.
      // If there is no wifi access when the app is started,
      // this app will continue loading until the conditions are satisfied.
      final conditions = FirebaseModelDownloadConditions(
          androidRequireWifi: true, iosAllowCellularAccess: false);

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

      File labelFile = File('${appDirectory.path}/download-labels.txt');

      try {
        await FirebaseStorage.instance
            .ref('blrber_ml_labels/labels.txt')
            .writeToFile(labelFile);
        print('vijay - $labelFile');
      } on firebase_core.FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        print(e);
        print('error downloading labels');
      }

      assert(await Tflite.loadModel(
            model: modelFile.path,
            labels: labelFile.path,
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
}
