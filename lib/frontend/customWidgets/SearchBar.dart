import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.items, this.onFilterList}) : super(key: key);

  final List<String> items;
  final void Function(List<String>) onFilterList;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _filterSearchResults(String query) {
    List<String> filteredList = [];
    if (query.isEmpty) {
      filteredList = widget.items;
    } else {
      filteredList = widget.items
          .where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    widget.onFilterList(filteredList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _filterSearchResults,
      controller: _searchController,
      decoration: InputDecoration(
        labelText: "Suche",
        hintText: "Suche",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
