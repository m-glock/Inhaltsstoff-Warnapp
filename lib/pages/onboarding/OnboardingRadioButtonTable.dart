import 'package:flutter/material.dart';

List<String> preferenceOptions = ['nichts', 'egal', 'wenig'];

class OnboardingRadioButtonTable extends StatefulWidget {
  OnboardingRadioButtonTable(
      {Key key, this.options, this.selectedItems, this.onChange})
      : super(key: key);

  final List<String> options;
  final Map<String, List<String>> selectedItems;
  final Function onChange;

  @override
  _OnboardingRadioButtonTableState createState() =>
      _OnboardingRadioButtonTableState();
}

class _OnboardingRadioButtonTableState
    extends State<OnboardingRadioButtonTable> {
  TextStyle tableHeadTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 10.0,
  );
  TextStyle tableCellsTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  );
  List<String> tableHeaderElements = ['', ...preferenceOptions];

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
                  textAlign:
                      tableHeaderIndex == 0 ? TextAlign.left : TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ),
          ),
          ...List.generate(
            widget.options.length,
            (listIndex) => TableRow(
              children: [
                TableCell(
                  child: Text(
                    widget.options[listIndex],
                    style: tableCellsTextStyle,
                  ),
                  verticalAlignment: TableCellVerticalAlignment.middle,
                ),
                ...List.generate(
                  preferenceOptions.length,
                  (preferenceStateIndex) => TableCell(
                    child: Radio(
                      value: preferenceOptions[preferenceStateIndex],
                      groupValue: widget.selectedItems["nothing"]
                              .contains(widget.options[listIndex])
                          ? "nichts"
                          : widget.selectedItems["few"]
                                  .contains(widget.options[listIndex])
                              ? "wenig"
                              : "egal",
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
