import 'dart:io';

import 'package:flutter/material.dart';

class ImageFullscreen extends StatefulWidget {
  final String imagePath;
  final String day;
  const ImageFullscreen({
    Key? key,
    required this.imagePath,
    required this.day,
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
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.file(
            File(
              widget.imagePath,
            ),
          ),
        ),
      ),
    );
  }
}
