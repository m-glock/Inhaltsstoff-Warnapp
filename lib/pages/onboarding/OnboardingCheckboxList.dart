import 'package:flutter/material.dart';
import './OnboardingSwitchList.dart';

class OnboardingCheckboxList extends StatefulWidget {
  OnboardingCheckboxList({Key key, this.list, this.onChange}) : super(key: key);

  final List<PreferenzesListTile> list;
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
          widget.list.length,
          (index) => CheckboxListTile(
            title: Text(widget.list[index].name),
            value: widget.list[index].isSelected,
            onChanged: (bool value) {
              widget.onChange(index, value);
            },
          ),
        ),
      ),
    );
  }
}
