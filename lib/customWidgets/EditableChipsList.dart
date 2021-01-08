import 'package:flutter/material.dart';

class EditableChipsList extends StatelessWidget {
  EditableChipsList({
    this.icon,
    this.title,
    this.items,
    this.onEdit,
  });

  final IconData icon;
  final String title;
  final List<String> items;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.merge(
                  TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.grey[900],
            ),
            onPressed: onEdit,
          ),
        ),
        Divider(
          thickness: 1.0,
          height: 8.0,
        ),
        if (items.length > 0)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Wrap(
              spacing: 12.0,
              runSpacing: 0.0,
              children: List<Widget>.generate(
                items.length,
                (int valueIndex) {
                  return Chip(
                    backgroundColor: Colors.grey[200],
                    label: Text(items[valueIndex]),
                  );
                },
              ).toList(),
            ),
          ),
        if (items.length > 0)
          Divider(
            thickness: 1.0,
            height: 8.0,
          ),
      ],
    );
  }
}
