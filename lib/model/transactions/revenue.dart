import 'package:flutter/material.dart';

class ModelRevenue {
  final String id;
  final String name;
  final String description;
  final String amount;
  final String date;
  final String category;
  final IconData icon;
  final String status;

  ModelRevenue(
      {required this.id,
      required this.name,
      required this.description,
      required this.amount,
      required this.date,
      required this.status,
      required this.icon,
      required this.category});
}
