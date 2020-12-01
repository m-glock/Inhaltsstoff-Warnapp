import 'package:flutter/material.dart';
import './OnboardingRadioButtonTable.dart';

class OnboardingSliderList extends StatefulWidget {
  OnboardingSliderList(
      {Key key, this.options, this.selectedItems, this.onChange})
      : super(key: key);

  final List<String> options;
  final Map<String, List<String>> selectedItems;
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
          widget.options.length,
          (index) => TableRow(
            children: [
              TableCell(
                child: Text(widget.options[index]),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(
                child: Slider(
                    min: 0.0,
                    max: 2.0,
                    value: preferenceOptions
                        .indexOf(
                          widget.selectedItems["nothing"]
                                  .contains(widget.options[index])
                              ? "nichts"
                              : widget.selectedItems["few"]
                                      .contains(widget.options[index])
                                  ? "wenig"
                                  : "egal",
                        )
                        .toDouble(),
                    onChanged: (double value) {
                      widget.onChange(index, preferenceOptions[value.toInt()]);
                    },
                    divisions: 2,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    label: widget.selectedItems["nothing"]
                            .contains(widget.options[index])
                        ? "nichts"
                        : widget.selectedItems["few"]
                                .contains(widget.options[index])
                            ? "wenig"
                            : "egal",
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
