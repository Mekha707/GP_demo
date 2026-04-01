import 'package:flutter/material.dart';

class LocationModel {
  final String city;
  final String state;
  final IconData icon;

  LocationModel(this.city, this.state, this.icon);

  @override
  String toString() => "$city, $state"; // النص الذي سيظهر عند البحث
}
