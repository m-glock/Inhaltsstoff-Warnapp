import 'package:flutter/material.dart';

class RadioButtonTable extends StatelessWidget {
  RadioButtonTable({this.options, this.items, this.onChange});

  final List<String> options;
  final Map<String, String> items;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    final List<String> tableHeaderElements = ['', ...options];
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
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign:
                      tableHeaderIndex == 0 ? TextAlign.left : TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ),
          ),
          ...List.generate(
            items.length,
            (listIndex) {
              String key = items.keys.toList()[listIndex];
              return TableRow(
                children: [
                  TableCell(
                    child: Text(
                      key,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    verticalAlignment: TableCellVerticalAlignment.middle,
                  ),
                  ...List.generate(
                    options.length,
                    (optionIndex) => TableCell(
                      child: Radio(
                        value: options[optionIndex],
                        groupValue: items[key],
                        onChanged: (value) {
                          onChange(listIndex, value);
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
