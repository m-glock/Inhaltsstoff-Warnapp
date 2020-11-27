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
        children: widget.list
            .map<Widget>((PreferenzesListTile listTile) => CheckboxListTile(
                  title: Text(listTile.name),
                  value: listTile.isSelected,
                  onChanged: (bool value) {
                    widget.onChange(listTile.name, value);
                  },
                ))
            .toList(),
      ),
    );
  }
}
