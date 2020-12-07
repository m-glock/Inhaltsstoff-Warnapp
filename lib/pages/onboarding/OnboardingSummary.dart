import 'package:flutter/material.dart';

class OnboardingSummary extends StatelessWidget {
  OnboardingSummary({this.preferences, this.onEditPreference});

  final Map<String, List<String>> preferences;
  final Function onEditPreference;

  final Map<String, Map> preferenceCategoryInfo = {
    "allergenes": {
      "icon": Icon(
        Icons.medical_services_outlined,
        color: Colors.blue,
      ),
      "title": "Allergien",
    },
    "nutrients": {
      "icon": Icon(
        Icons.insights,
        color: Colors.blue,
      ),
      "title": "Erwünschte Nährstoffe",
    },
    "unwantedIngredientsNothing": {
      "icon": Icon(
        Icons.remove_circle_outline,
        color: Colors.blue,
      ),
      "title": "Verbotene Inhaltstoffe",
    },
    "unwantedIngredientsFew": {
      "icon": Icon(
        Icons.trending_down,
        color: Colors.blue,
      ),
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
                  leading: preferenceCategoryInfo[key]["icon"],
                  title: Text(
                    preferenceCategoryInfo[key]["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[800],
                    ),
                    onPressed: () => onEditPreference(key),
                  ),
                ),
                Divider(
                  thickness: 1.0,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              //side: BorderSide(color: Colors.grey),
                            ),
                            label: Text(preferences[key][valueIndex]),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                if (preferences[key].length > 0)
                  Divider(
                    thickness: 1.0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}