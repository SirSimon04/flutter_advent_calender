import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/toast_service.dart';

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
  void saveImage() async {
    await ImageGallerySaver.saveImage(File(
      widget.imagePath,
    ).readAsBytesSync());
    ToastService.showLongToast("Das Bild wurde erfolgreich heruntergeladen");
  }

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
        actions: [
          IconButton(
            onPressed: saveImage,
            icon: const Icon(Icons.file_download),
          )
        ],
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
