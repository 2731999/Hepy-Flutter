import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/frontcamera/res/emums.dart';
import 'package:hepy/app/Utils/frontcamera/frontCamera.dart';
import 'package:hepy/app/modules/selfiecamera/controller/selfiecamera_controller.dart';

class SelfieCameraView extends StatefulWidget {
  SelfieCameraView({Key? key}) : super(key: key);
  SelfieController selfieController = SelfieController();

  @override
  State<SelfieCameraView> createState() => _SelfieCameraViewState();
}

class _SelfieCameraViewState extends State<SelfieCameraView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrontCamera(
          autoCapture: false,
          defaultCameraLens: CameraLens.front,
          showCameraLensControl: true,
          showFlashControl: false,
          enableAudio: true,
          onCapture: (File? image) {
            Get.back(result: [image?.path]);
          }),
    );
  }
}
