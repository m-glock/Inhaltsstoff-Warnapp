import 'package:flutter/material.dart';

enum preferenceState {
  never,
  regardless,
  few,
}

class UnwantedIngredientsListTile {
  UnwantedIngredientsListTile(this.name, this.preference);
  String name;
  preferenceState preference;
}

class OnboardingSliderList extends StatefulWidget {
  OnboardingSliderList({Key key, this.list, this.onChange}) : super(key: key);

  final List<UnwantedIngredientsListTile> list;
  final Function onChange;

  @override
  _OnboardingSliderListState createState() => _OnboardingSliderListState();
}

class _OnboardingSliderListState extends State<OnboardingSliderList> {
  TextStyle tableHeadTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 10.0,
  );
  TextStyle tableCellsTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  );
  List<String> tableHeaderElements = ['test', 'nichts', 'egal', 'wenig'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1)
        },
        children: [
          TableRow(
            children: List.generate(
              tableHeaderElements.length,
              (tableHeaderIndex) => TableCell(
                child: Text(
                  tableHeaderElements[tableHeaderIndex],
                  style: tableHeadTextStyle,
                  textAlign: tableHeaderIndex == 0
                      ? TextAlign.left
                      : TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ),
          ),
          ...List.generate(
            widget.list.length,
            (listIndex) => TableRow(
              children: [
                TableCell(
                  child: Text(
                    widget.list[listIndex].name,
                    style: tableCellsTextStyle,
                  ),
                  verticalAlignment: TableCellVerticalAlignment.middle,
                ),
                ...List.generate(
                  preferenceState.values.length,
                  (preferenceStateIndex) => TableCell(
                    child: Radio(
                      value: preferenceState.values[preferenceStateIndex],
                      groupValue: widget.list[listIndex].preference,
                      onChanged: (value) {
                        widget.onChange(listIndex, value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
