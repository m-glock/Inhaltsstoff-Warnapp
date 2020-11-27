import 'package:flutter/material.dart';
import './OnboardingRadioButtonTable.dart';

class OnboardingSliderList extends StatefulWidget {
  OnboardingSliderList({Key key, this.list, this.onChange}) : super(key: key);

  final List<UnwantedIngredientsListTile> list;
  final Function onChange;
  @override
  _OnboardingSliderListState createState() => _OnboardingSliderListState();
}

class _OnboardingSliderListState extends State<OnboardingSliderList> {
  List<String> tableHeaderElements = preferenceOptions;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        children: List.generate(
          widget.list.length,
          (index) => TableRow(
            children: [
              TableCell(
                child: Text(widget.list[index].name),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(
                child: Slider(
                    min: 0.0,
                    max: 2.0,
                    value: preferenceOptions
                        .indexOf(widget.list[index].preference)
                        .toDouble(),
                    onChanged: (double value) {
                      widget.onChange(index, preferenceOptions[value.toInt()]);
                    },
                    divisions: 2,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    label: widget.list[index].preference,
                    semanticFormatterCallback: (double newValue) {
                      return preferenceOptions[newValue.toInt()];
                    }),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
