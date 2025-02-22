import 'package:flutter/material.dart';

class AzkarCategory {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final int azkarCount;
  final String description;

  const AzkarCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.azkarCount,
    required this.description,
  });

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
      azkarCount: json['azkarCount'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'iconCodePoint': icon.codePoint,
      'azkarCount': azkarCount,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
} 