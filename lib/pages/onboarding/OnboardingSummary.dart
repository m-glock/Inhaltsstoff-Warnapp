import 'package:flutter/material.dart';

class OnboardingSummary extends StatelessWidget {
  OnboardingSummary({this.preferences, this.onEditPreference});

  final Map<String, List<String>> preferences;
  final Function onEditPreference;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return Chip(
              label: Text('Item $index'),
            );
          },
        ).toList(),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }
}
