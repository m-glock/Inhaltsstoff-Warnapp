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
  final tableHeadTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 10.0,
  );
  final tableCellsTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  );
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
            children: [
              TableCell(
                child: Text(
                  '',
                  style: tableHeadTextStyle,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(
                child: Text(
                  'nichts'.toUpperCase(),
                  style: tableHeadTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(
                child: Text(
                  'egal'.toUpperCase(),
                  style: tableHeadTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              TableCell(
                child: Text(
                  'wenig'.toUpperCase(),
                  style: tableHeadTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ],
          ),
          ...widget.list
              .map(
                (listElement) => TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        listElement.name,
                        style: tableCellsTextStyle,
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    ...preferenceState.values
                        .map(
                          (preferenceState) => TableCell(
                            child: Radio(
                              value: preferenceState,
                              groupValue: listElement.preference,
                              onChanged: (value) {
                                setState(() {
                                  listElement.preference = value;
                                });
                                widget.onChange(listElement.name, value);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
