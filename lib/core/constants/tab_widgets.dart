import 'package:flutter/material.dart';
import 'package:phraso/features/languages/pages/language_page.dart';
import 'package:phraso/features/planner/pages/planner_page.dart';

class TabWidgets {
  static final List<Widget> tabwidgets = <Widget>[
    const Languagepage(),
    const Plannerpage(),
    const Languagepage(),
    const Languagepage(),
    const Languagepage(),
  ];
}
