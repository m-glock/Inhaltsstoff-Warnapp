import 'dart:ffi';

import 'package:flutter/material.dart';

class Expandable extends StatefulWidget {
  final bool isExpanded;
  final Widget child;

  const Expandable(
      {Key key, this.isExpanded, this.child})
      : super(key: key);

  @override
  _ExpandableState createState() =>
      _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: widget.isExpanded ? widget.child : nullptr,
    );
  }
}