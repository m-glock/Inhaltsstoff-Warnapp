import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanningBarcodeForm extends StatefulWidget {
  final Function onCancel;
  final Function onSubmit;

  const ScanningBarcodeForm({
    Key key,
    this.onCancel,
    this.onSubmit,
  }) : super(key: key);

  @override
  ScanningBarcodeFormState createState() {
    return ScanningBarcodeFormState();
  }
}

class ScanningBarcodeFormState extends State<ScanningBarcodeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  String _barcode;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Barcode',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Bitte geben Sie einen Barcode ein';
              } else if (value.length > 13) {
                return 'Maximal 13 Stellen sind erlaubt';
              } else if (value.length < 8) {
                return 'Mindestens 8 Stellen sind erforderlich';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              _barcode = value;
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: Text('Abbrechen'),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        widget.onSubmit(_barcode);
                      }
                    },
                    child: Text('Submit'),
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColorLight,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
