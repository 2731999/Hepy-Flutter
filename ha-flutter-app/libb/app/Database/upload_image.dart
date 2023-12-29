import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hepy/app/modules/signup_photos/controller/signup_photos_controller.dart';

class UploadImage {
  /*Future<UploadTask?> uploadSingleImage(File file, String? fileName) async {
    //Set File Name
    final auth = FirebaseAuth.instance;
    String tokenAuth =
        await FirebaseAuth.instance.currentUser!.getIdToken(false);
    debugPrint("Tokens  =====> $tokenAuth");

    //Create Reference
    Reference reference = FirebaseStorage.instance
        .ref('user-photos/')
        .child(auth.currentUser!.uid)
        .child(fileName!);
    //Now We have to check status of UploadTask
    UploadTask uploadTask = reference.putData(file.readAsBytesSync());

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          SignupPhotosController().isShowProgress.value = true;
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is ${(progress).toStringAsFixed(2)}% complete.");
          SignupPhotosController().uploadProgress.value = (progress).toStringAsFixed(2);
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          SignupPhotosController().isShowProgress.value = false;
          print("Upload was canceled");
          break;
        case TaskState.error:
          SignupPhotosController().isShowProgress.value = false;
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          SignupPhotosController().isShowProgress.value = false;
          // Handle successful uploads on complete
          // ...
          break;
      }
    });

    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    debugPrint("Doawnload image Url ====> $urlDownload");
    return uploadTask;
  }*/
}
