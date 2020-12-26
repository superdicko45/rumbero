import 'package:flutter/material.dart';

import 'package:rumbero/ui/styles/theme.dart' as Theme;

import 'package:rumbero/logic/entity/models/category_model.dart';

class ChipSlider extends StatelessWidget {

  final List<Category> categories;

  const ChipSlider({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<Widget> items = List<Widget>();

    for (var category in categories) {
      items.add( newChip(category.genero) );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.0,
      runSpacing: 20.0,
      children: items
    );
  }

  Widget newChip(String text){
    return Chip(
      label: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.Colors.loginGradientStart,
      elevation: 5.0,
    );
  }
}