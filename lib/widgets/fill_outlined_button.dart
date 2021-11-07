import 'package:flutter/material.dart';

class FillOutlineButton extends StatelessWidget {
  final bool isFilled;
  final VoidCallback onPress;
  final String text;

  const FillOutlineButton(
    this.isFilled,
    this.text,
    this.onPress, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.white)),
      color: isFilled ? Colors.white : Colors.transparent,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? Colors.black : Colors.white,
          fontSize: 12,
        ),
      ),
      elevation: isFilled ? 2 : 0,
    );
  }
}
