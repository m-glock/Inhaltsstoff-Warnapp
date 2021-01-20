// Inside image_detail.dart file

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import './scanningCustomWidgets/ScanningTextDetectionPainter.dart';

class ScanningTextrecognition extends StatefulWidget {
  final File file;
  ScanningTextrecognition(this.file);

  @override
  _ScanningTextrecognitionState createState() =>
      new _ScanningTextrecognitionState(file);
}

class _ScanningTextrecognitionState extends State<ScanningTextrecognition> {
  _ScanningTextrecognitionState(this.path);

  final File path;

  Size _imageSize;
  String recognizedText = "Lade ...";
  List<TextBlock> _elements = [];

  void _initializeVision() async {
    final File imageFile = path;

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String text = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        text += line.text + '\n';
      }
      text += '\n';
      _elements.add(block);
    }

    if (this.mounted) {
      setState(() {
        recognizedText = text;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Erkannter Text"),
      ),
      backgroundColor: Colors.black,
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.maxFinite,
                      color: Colors.black,
                      child: CustomPaint(
                        foregroundPainter:
                            ScanningTextDetectorPainter(_imageSize, _elements),
                        child: AspectRatio(
                          aspectRatio: _imageSize.aspectRatio,
                          child: Image.file(
                            path,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Zutaten",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 210,
                            child: SingleChildScrollView(
                              child: Text(
                                recognizedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
}
