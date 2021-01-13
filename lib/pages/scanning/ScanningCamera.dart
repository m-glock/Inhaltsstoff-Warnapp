import 'dart:io';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import './ScanningCropImage.dart';
// import './ScanningTextrecognition.dart';
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0))),
                  child: CameraPreview(_controller),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: LabelledIconButton(
                        label: '',
                        icon: Icons.camera,
                        isPrimary: true,
                        onPressed: () async {
                          await _takePicture().then((String path) {
                            if (path != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // ScanningTextrecognition(path),
                                      ScanningCropImage(imgPath: path,),
                                ),
                              );
                            }
                          });
                        },
                        iconSize: 52,
                      ),
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

    _controller = CameraController(cameras[0], ResolutionPreset.veryHigh);
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
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
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
