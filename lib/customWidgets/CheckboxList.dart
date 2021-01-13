import 'package:flutter/material.dart';

class CheckboxList extends StatelessWidget {
  CheckboxList({this.items, this.onChange});

  final Map<String, bool> items;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          items.length,
          (index) {
            String key = items.keys.toList()[index];
            return CheckboxListTile(
              title: Text(
                key,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              value: items[key],
              onChanged: (bool value) {
                onChange(index, value);
              },
              activeColor: Theme.of(context).primaryColor,
            );
          },
        ),
      ),
    );
  }
}
