import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/material.dart';

import './ScanningTextrecognition.dart';

class ScanningCropImage extends StatefulWidget {
  final String imgPath;

  ScanningCropImage({this.imgPath});

  @override
  _ScanningCropImageState createState() => new _ScanningCropImageState(imgPath);
}

class _ScanningCropImageState extends State<ScanningCropImage> {
  _ScanningCropImageState(this.path);

  final String path;
  final cropKey = GlobalKey<CropState>();
  File _sample;
  File _lastCropped;

  @override
  void initState() {
    super.initState();
    _setSample();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zuschneiden auf Inhaltsstoffe'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: _sample == null
            ? Center(child: CircularProgressIndicator())
            : _buildCroppingImageView(), //Image.asset('assets/images/test.jpg'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _sample?.delete();
    _lastCropped?.delete();
  }

  Future<void> _setSample() async {
    var file = await _getImageFile(path);

    setState(() {
      _sample = file;
    });
  }

  Future<File> _getImageFile(String path) async {
    final file = File('$path');
    return file;
  }

  Widget _buildCroppingImageView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(_sample, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                  child: Text(
                    'Zurücksetzen',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Colors.white,
                  onPressed: null),
              RaisedButton(
                child: Text(
                  'Zuschneiden',
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _sample,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ScanningTextrecognition(
          file
        ),
      ),
    );
  }
}
