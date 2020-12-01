import 'package:flutter/material.dart';

class OnboardingSwitchList extends StatefulWidget {
  OnboardingSwitchList(
      {Key key, this.options, this.selectedItems, this.onChange})
      : super(key: key);

  final List<String> options;
  final List<String> selectedItems;
  final Function onChange;

  @override
  _OnboardingSwitchListState createState() => _OnboardingSwitchListState();
}

class _OnboardingSwitchListState extends State<OnboardingSwitchList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          widget.options.length,
          (index) => SwitchListTile(
            title: Text(widget.options[index]),
            value: widget.selectedItems.contains(widget.options[index]),
            onChanged: (bool value) {
              widget.onChange(index, value);
            },
          ),
        ),
      ),
    );
  }
}
