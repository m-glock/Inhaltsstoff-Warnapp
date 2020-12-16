import 'package:flutter/material.dart';

import './ScanningBarcodeForm.dart';

class ScanningBarcodeDialog extends StatelessWidget {
  final Function onCancel;
  final Function onSubmit;
  const ScanningBarcodeDialog(this.onCancel, this.onSubmit, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "Manuelle Eingabe",
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      children: [
        ScanningBarcodeForm(onCancel, onSubmit),
      ],
      titlePadding: EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
    );
  }
}
