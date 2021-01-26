import 'dart:io';

import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../main.dart';
import '../../customWidgets/LabelledIconButton.dart';

class ScanningCamera extends StatefulWidget {
  @override
  _ScanningCameraState createState() => _ScanningCameraState();
}

class _ScanningCameraState extends State {
  CameraController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inhaltsstoffe fotografieren'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: _controller.value.isInitialized
          ? Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                CameraPreview(_controller),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: LabelledIconButton(
                      label: '',
                      icon: Icons.camera,
                      isPrimary: true,
                      onPressed: () {
                        _takePicture().then((String path) {
                          if (path != null) {
                            Navigator.pushNamed(
                              context,
                              '/crop_image',
                              arguments: path,
                            );
                          }
                        });
                      },
                      iconSize: 52,
                    ),
                  ),
                )
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(cameras[0], ResolutionPreset.veryHigh,
        enableAudio: false);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    // Checking whether the controller is initialized
    if (!_controller.value.isInitialized) {
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      return null;
    }

    try {
      // Captures the image and saves it to the
      // provided path
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }
}
