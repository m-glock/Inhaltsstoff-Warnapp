import 'package:flutter/material.dart';

class OnboardingCheckboxList extends StatefulWidget {
  OnboardingCheckboxList(
      {Key key, this.options, this.selectedItems, this.onChange})
      : super(key: key);

  final List<String> options;
  final List<String> selectedItems;
  final Function onChange;

  @override
  _OnboardingCheckboxListState createState() => _OnboardingCheckboxListState();
}

class _OnboardingCheckboxListState extends State<OnboardingCheckboxList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          widget.options.length,
          (index) => CheckboxListTile(
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
