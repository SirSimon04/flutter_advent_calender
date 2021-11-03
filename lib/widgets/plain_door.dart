import 'package:flutter/material.dart';

class PlainDoor extends StatefulWidget {
  final int? animSec;
  final Size size;
  final String imgSrc;
  final bool isShadow;
  final Future<void> Function(bool, AnimationController?)? func;
  final String? day;
  const PlainDoor({
    Key? key,
    required this.size,
    required this.imgSrc,
    this.func,
    this.isShadow = false,
    this.animSec,
    this.day,
  }) : super(key: key);

  @override
  _PlainDoorState createState() => _PlainDoorState();
}

class _PlainDoorState extends State<PlainDoor>
    with SingleTickerProviderStateMixin {
  AnimationController? _at;
  Animation<double>? _anim;

  @override
  void initState() {
    if (widget.animSec != null) {
      _at = AnimationController(
          vsync: this, duration: Duration(seconds: widget.animSec!))
        ..addListener(() {
          if (!mounted) return;
          setState(() {});
        });
      _anim = Tween<double>(begin: 0, end: 1.5).animate(_at!);
      if (!mounted) return;
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
              bool loadCheck = _anim != null || _anim != null;
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
        )..rotateY(_anim?.value ?? 0),
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: widget.isShadow
                ? ColorFilter.mode(Colors.black, BlendMode.srcIn)
                : null,
            image: AssetImage(widget.imgSrc),
          ),
        ),
        child: Center(
          child: Text(
            widget.day ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 4.8),
          ),
        ),
      ),
    );
  }
}
