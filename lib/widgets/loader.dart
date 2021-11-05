import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  Loader(
      {Key? key,
      this.opacity: 0.5,
      this.dismissibles: false,
      this.color: Colors.black,
      this.loadingTxt: 'Loading...'})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Container(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: CircularProgressIndicator(),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 200),
            child: Text(
              loadingTxt,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
