import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanningBarcodeDialog extends StatefulWidget {
  const ScanningBarcodeDialog({Key key}) : super(key: key);

  @override
  _ScanningBarcodeDialogState createState() => _ScanningBarcodeDialogState();
}

class _ScanningBarcodeDialogState extends State<ScanningBarcodeDialog> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Barcode manuell eingeben"),
      content: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
        ],
        keyboardType: TextInputType.number,
        controller: _textController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.dialpad, color: Colors.grey),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () {
            Navigator.pop(context, _textController.text);
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            if (_textController.text.length != 13) {
              return;
            } else {
              Navigator.pop(context, _textController.text);
            }
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
