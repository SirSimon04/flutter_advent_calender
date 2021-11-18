import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';

class ImageFullscreen extends StatefulWidget {
  final String imagePath;
  final String day;
  final CalendarModel calendar;
  const ImageFullscreen({
    Key? key,
    required this.imagePath,
    required this.day,
    required this.calendar,
  }) : super(key: key);

  @override
  _ImageFullscreenState createState() => _ImageFullscreenState();
}

class _ImageFullscreenState extends State<ImageFullscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Foto vom ${widget.day}. 12.",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 32,
            ),
            if (widget.day == "24")
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.calendar.msg,
                  // "Hallo das hier ist eine ziemlich lange Nachricht für Weihnachten, auch Weihnachtsnachricht genannt. Hallo das hier ist eine ziemlich lange Nachricht für Weihnachten, auch Weihnachtsnachricht genannt",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(
              height: 32,
            ),
            InteractiveViewer(
              clipBehavior: Clip.none,
              child: Image.file(
                File(
                  widget.imagePath,
                ),
              ),
            ),
            const SizedBox(
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
