import 'package:flutter/material.dart';

enum RestaurantColors {
  orange("orange", Colors.orange);

  const RestaurantColors(this.name, this.color);
  final String name;
  final Color color;
}
