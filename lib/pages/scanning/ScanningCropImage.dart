import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ScanningCropImage extends StatefulWidget {
  const ScanningCropImage({ Key key }) : super(key: key);

  @override
  _ScanningCropImageState createState() => _ScanningCropImageState();
}

class _ScanningCropImageState extends State<ScanningCropImage> {
  final cropKey = GlobalKey<CropState>();
  String _imageName = 'test.jpg';
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
    var file = await _getImageFileFromAssets(_imageName);

    setState(() {
      _sample = file;
    });
  }

  Future<File> _getImageFileFromAssets(String imageName) async {
    final byteData = await rootBundle.load('assets/images/$imageName');

    final file = File('${(await getTemporaryDirectory()).path}/$imageName');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

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
                child: Text('Zurücksetzen', style: TextStyle(color: Theme.of(context).primaryColor),),
                color: Colors.white,
                onPressed: null),
              RaisedButton(
                child: Text('Zuschneiden'),
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
  }
}