import 'dart:io';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/material.dart';

import './ScanningTextrecognition.dart';
import '../../customWidgets/LabelledIconButton.dart';

class ScanningCropImage extends StatefulWidget {
  final String imgPath;

  ScanningCropImage(this.imgPath);

  @override
  _ScanningCropImageState createState() => new _ScanningCropImageState();
}

class _ScanningCropImageState extends State<ScanningCropImage> {
  _ScanningCropImageState();

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
      backgroundColor: Colors.black,
      body: Container(
        child: _sample == null
            ? Center(child: CircularProgressIndicator())
            : _buildCroppingImageView(),
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
    var file = await _getImageFile(widget.imgPath);

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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: LabelledIconButton(
              label: '',
              icon: Icons.cut,
              isPrimary: true,
              onPressed: () => _cropImage(),
              iconSize: 52,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _sample,
      preferredSize: (3000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();
    _lastCropped?.delete();
    debugPrint('FILE:         $file');
    _lastCropped = file;

    Navigator.pushNamed(
      context,
      '/result_textrecognition', 
      arguments:file,
    );
  }
}
