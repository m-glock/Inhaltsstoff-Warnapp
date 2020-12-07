import 'package:flutter/material.dart';

class CheckboxList extends StatelessWidget {
  CheckboxList({this.options, this.selectedItems, this.onChange});

  final List<String> options;
  final List<String> selectedItems;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          options.length,
          (index) => CheckboxListTile(
            title: Text(options[index]),
            value: selectedItems.contains(options[index]),
            onChanged: (bool value) {
              onChange(index, value);
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
