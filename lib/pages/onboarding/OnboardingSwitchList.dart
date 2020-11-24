import 'package:flutter/material.dart';

class PreferenzesListTile {
  PreferenzesListTile(this.name, this.isSelected);
  String name;
  bool isSelected;
}

class OnboardingSwitchList extends StatefulWidget {
  OnboardingSwitchList({Key key, this.list, this.onChange}) : super(key: key);

  final List<PreferenzesListTile> list;
  final Function onChange;

  @override
  _OnboardingSwitchListState createState() => _OnboardingSwitchListState();
}

class _OnboardingSwitchListState extends State<OnboardingSwitchList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: widget.list
            .map<Widget>((PreferenzesListTile listTile) => SwitchListTile(
                  title: Text(listTile.name),
                  value: listTile.isSelected,
                  onChanged: (bool value) {
                    setState(() {
                      listTile.isSelected = value;
                    });
                    widget.onChange(listTile.name, value);
                  },
                ))
            .toList(),
      ),
    );
  }
}
