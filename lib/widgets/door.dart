import 'package:flutter/material.dart';

class Door extends StatefulWidget {
  final int? animSec;
  final Size size;
  final String imgSrc;
  final bool isShadow;
  final Future<void> Function(bool, AnimationController?)? func;
  const Door(
      {Key? key,
      required this.size,
      required this.imgSrc,
      this.func,
      this.isShadow = false,
      this.animSec})
      : super(key: key);

  @override
  _DoorState createState() => _DoorState();
}

class _DoorState extends State<Door> with SingleTickerProviderStateMixin {
  AnimationController? _at;
  Animation<double>? _anim;

  @override
  void initState() {
    if (widget.animSec != null) {
      this._at = AnimationController(
          vsync: this, duration: Duration(seconds: widget.animSec!))
        ..addListener(() {
          if (!this.mounted) return;
          setState(() {});
        });
      this._anim = Tween<double>(begin: 0, end: 1.2).animate(_at!);
      if (!this.mounted) return;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (widget.isShadow || widget.func == null)
            ? null
            : () {
                bool loadCheck = this._anim != null || this._anim != null;
                widget.func!(loadCheck, _at);
              },
        child: Container(
          transform: Matrix4(
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          )..rotateY(this._anim?.value ?? 0),
          width: widget.size.width,
          height: widget.size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: widget.isShadow
                      ? ColorFilter.mode(Colors.black, BlendMode.srcIn)
                      : null,
                  image: AssetImage(widget.imgSrc))),
        ));
  }
}
