import 'package:flutter/material.dart';

class EditableTitle extends StatefulWidget {
  const EditableTitle({Key key, this.originalTitle, this.onTitleChanged})
      : super(key: key);

  final String originalTitle;
  final void Function(String) onTitleChanged;

  @override
  _EditableTitleState createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  TextEditingController _textController;
  String _title;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _title = widget.originalTitle;
    _textController = TextEditingController(
      text: _title,
    );
    _setTextControllerSelection();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: TextField(
              controller: _textController,
              autofocus: true,
              onSubmitted: (String value) {
                _title = value;
                widget.onTitleChanged(value);
                setState(() {
                  _isEditing = false;
                });
              },
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _title,
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _setTextControllerSelection();
                        _isEditing = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _setTextControllerSelection() {
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _title.length,
    );
  }
}
