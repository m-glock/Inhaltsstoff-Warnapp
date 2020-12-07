import 'package:flutter/material.dart';

class OnboardingSummary extends StatelessWidget {
  OnboardingSummary({this.preferences, this.onEditPreference});

  final Map<String, List<String>> preferences;
  final Function onEditPreference;

  final Map<String, Map> preferenceCategoryInfo = {
    "allergens": {
      "icon": Icons.medical_services_outlined,
      "title": "Allergien",
    },
    "nutrients": {
      "icon": Icons.insights,
      "title": "Erwünschte Nährstoffe",
    },
    "unwantedIngredientsNothing": {
      "icon": Icons.remove_circle_outline,
      "title": "Verbotene Inhaltstoffe",
    },
    "unwantedIngredientsFew": {
      "icon": Icons.trending_down,
      "title": "Zu reduzierende Inhaltstoffe",
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          preferences.length,
          (keyIndex) {
            String key = preferences.keys.elementAt(keyIndex);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    preferenceCategoryInfo[key]["icon"],
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    preferenceCategoryInfo[key]["title"],
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
                    onPressed: () => onEditPreference(key),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  height: 8.0,
                ),
                if (preferences[key].length > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 0.0,
                      children: List<Widget>.generate(
                        preferences[key].length,
                        (int valueIndex) {
                          return Chip(
                            backgroundColor: Colors.grey[200],
                            label: Text(preferences[key][valueIndex]),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                if (preferences[key].length > 0)
                  Divider(
                    thickness: 1.0,
                    height: 8.0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
