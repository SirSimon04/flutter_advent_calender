import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/plain_door.dart';
import 'package:particles_flutter/particles_flutter.dart';

_CalendarDoorState globalState = _CalendarDoorState();

class CalendarDoor extends StatefulWidget {
  final String imgSrc;
  final String? day;
  final Size doorSize;
  CalendarDoor({
    required this.imgSrc,
    this.day,
    required this.doorSize,
  });

  @override
  State<CalendarDoor> createState() => _CalendarDoorState();
}

class _CalendarDoorState extends State<CalendarDoor> {
  bool shouldShowParticles = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DoorPressed>(
      onNotification: (val) {
        print("tapped from parent");
        setState(() {
          shouldShowParticles = !shouldShowParticles;
        });
        return true;
      },
      child: Stack(
        children: [
          PlainDoor(
            imgSrc: widget.imgSrc,
            size: widget.doorSize,
            isShadow: true,
          ),
          Positioned(
            bottom: 10,
            right: 4,
            child: Image.asset(
              "assets/present.png",
              width: 8,
              height: 8,
            ),
          ),
          Visibility(
            visible: shouldShowParticles,
            child: CircularParticle(
              key: UniqueKey(),
              awayRadius: 800,
              numberOfParticles: 7000,
              speedOfParticles: 0.5,
              height: widget.doorSize.height,
              width: widget.doorSize.width,
              onTapAnimation: false,
              particleColor: const Color(0xFFE0AA3E),
              awayAnimationDuration: Duration(milliseconds: 600),
              maxParticleSize: 0.15,
              isRandSize: true,
              isRandomColor: true,
              randColorList: [const Color(0xFFD4AF37), const Color(0xFFF7EF8A)],
              awayAnimationCurve: Curves.easeInOutBack,
              enableHover: false,
              hoverColor: Colors.white,
              hoverRadius: 90,
              connectDots: false, //not recommended
            ),
          ),
          PlainDoor(
            animSec: 1,
            func: (bool check, AnimationController? ct) async {
              if (ct == null) return;
              if (ct.isAnimating) return;
              if (ct.isCompleted) {
                ct.reverse();
                return;
              }
              ct.forward();
              return;
            },
            size: widget.doorSize,
            imgSrc: widget.imgSrc,
            day: widget.day,
          ),
        ],
      ),
    );
  }
}
