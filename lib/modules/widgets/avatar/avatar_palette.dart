import 'dart:math';

import 'package:flutter/material.dart';

/// Shared palette + artboard tables for the Rive avatar system.
/// Ported from the Bapcare mobile app; indices must stay in sync with the
/// `avatar.riv` ViewModel bindings.

/// Default avatar configuration — randomised so every new user looks unique.
Map<String, dynamic> defaultAvatarConfig() {
  final r = Random();
  final gender = r.nextInt(2);
  return {
    'genderHead': gender,
    'skinColorIndex': r.nextInt(6),
    'bodyArtIndex': r.nextInt(7),
    'bodyColorIndex': r.nextInt(10),
    'hairArtIndex': r.nextInt(6),
    'hairColorIndex': r.nextInt(10),
    'hasBeard': gender == 0 ? r.nextInt(2) : 0,
    'bgColorIndex': r.nextInt(10),
  };
}

const List<Color> kSkinColors = [
  Color(0xFF8D5524),
  Color(0xFFC68642),
  Color(0xFFE0AC69),
  Color(0xFFF1C27D),
  Color(0xFFFFDBAC),
  Color(0xFFFEE2C4),
];

const List<Color> kHairColors = [
  Color(0xFF2C1B18),
  Color(0xFF4A3728),
  Color(0xFF7C533E),
  Color(0xFFB5651D),
  Color(0xFFD4A65A),
  Color(0xFFE8C07A),
  Color(0xFFF0E68C),
  Color(0xFFFF8C00),
  Color(0xFFCC3333),
  Color(0xFF808080),
];

const List<Color> kBodyColors = [
  Color(0xFFFFEB3B),
  Color(0xFF4CAF50),
  Color(0xFF2196F3),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFFFF5722),
  Color(0xFF00BCD4),
  Color(0xFFFF9800),
  Color(0xFF795548),
  Color(0xFF607D8B),
];

const List<Color> kBgColors = [
  Color(0xFFFFCDD2),
  Color(0xFFF8BBD0),
  Color(0xFFE1BEE7),
  Color(0xFFC5CAE9),
  Color(0xFFBBDEFB),
  Color(0xFFB2DFDB),
  Color(0xFFC8E6C9),
  Color(0xFFFFF9C4),
  Color(0xFFFFE0B2),
  Color(0xFFD7CCC8),
];

const List<String> kHeadArtboards = ['head_male', 'head_female'];

const List<String> kHairArtboards = [
  'hair_0',
  'hair_1',
  'hair_2',
  'hair_3',
  'hair_4',
  'hair_5',
];

const List<String> kBodyArtboards = [
  'body_0',
  'body_1',
  'body_2',
  'body_3',
  'body_4',
  'body_5',
  'body_6',
];

Color darkenColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

/// Background color for a given avatar config (used as accent in the UI).
Color avatarBgColor(Map<String, dynamic>? config) {
  if (config == null) return kBgColors[0];
  final idx = (config['bgColorIndex'] as int? ?? 0).clamp(0, kBgColors.length - 1);
  return kBgColors[idx];
}
