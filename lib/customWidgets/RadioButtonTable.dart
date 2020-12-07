import 'package:flutter/material.dart';

class RadioButtonTable extends StatelessWidget {
  RadioButtonTable(
      {this.options, this.itemList, this.selectedItems, this.onChange});

  final List<String> itemList;
  final List<String> options;
  final Map<String, List<String>> selectedItems;
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
                  style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  textAlign:
                      tableHeaderIndex == 0 ? TextAlign.left : TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ),
          ),
          ...List.generate(
            itemList.length,
            (listIndex) => TableRow(
              children: [
                TableCell(
                  child: Text(itemList[listIndex],
                      style: Theme.of(context).textTheme.bodyText1),
                  verticalAlignment: TableCellVerticalAlignment.middle,
                ),
                ...List.generate(
                  options.length,
                  (optionIndex) => TableCell(
                    child: Radio(
                      value: options[optionIndex],
                      groupValue: selectedItems[options[0]]
                              .contains(itemList[listIndex])
                          ? options[0]
                          : selectedItems[options[1]]
                                  .contains(itemList[listIndex])
                              ? options[1]
                              : options[2],
                      onChanged: (value) {
                        onChange(listIndex, value);
                      },
                      activeColor: Theme.of(context).primaryColor,
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
