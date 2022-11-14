import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

CupertinoTextFieldData cupertinoTextFieldStyle = CupertinoTextFieldData(
  padding: const EdgeInsets.all(16),
  placeholderStyle: const TextStyle(
    color: Colors.white70,
  ),
  decoration: BoxDecoration(
    color: CupertinoColors.quaternarySystemFill,
    border: Border.all(
      color: CupertinoColors.inactiveGray,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);
