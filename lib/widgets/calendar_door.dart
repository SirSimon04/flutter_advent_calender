import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/screens/image_fullscreen/image_fullscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/plain_door.dart';
import 'package:particles_flutter/particles_flutter.dart';

_CalendarDoorState globalState = _CalendarDoorState();

class CalendarDoor extends StatefulWidget {
  final String imgSrc;
  final String? day;
  final Size doorSize;
  final bool isLast;
  final int iterator;
  final CalendarModel calendar;
  final bool isDoorOpen;
  const CalendarDoor(
      {required this.imgSrc,
      this.day,
      required this.doorSize,
      this.isLast = false,
      required this.iterator,
      required this.calendar,
      required this.isDoorOpen,
      Key? key})
      : super(key: key);

  @override
  State<CalendarDoor> createState() => _CalendarDoorState();
}

class _CalendarDoorState extends State<CalendarDoor> {
  bool shouldShowParticles = false;

  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DoorPressed>(
      onNotification: (val) {
        setState(() {
          shouldShowParticles = !shouldShowParticles;
        });
        return true;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PlainDoor(
            imgSrc: widget.imgSrc,
            size: widget.doorSize,
            isShadow: true,
            iterator: 0,
          ),
          FutureBuilder<Directory>(
              future: getApplicationDocumentsDirectory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  try {
                    imageUrl =
                        "${snapshot.data!.path}/${widget.calendar.id}_${widget.iterator}.jpg";
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ImageFullscreen(
                              imagePath: imageUrl,
                              day: widget.day ?? "",
                              calendar: widget.calendar,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: widget.doorSize.height - 5,
                        width: widget.doorSize.width - 2,
                        child: Image.file(
                          File(
                              "${snapshot.data!.path}/${widget.calendar.id}_${widget.iterator}.jpg"),
                          width: 8,
                          height: 8,
                          // alignment: Alignment.center,
                          // fit: BoxFit.cover,

                          // width: widget.doorSize.width,
                          // height: widget.doorSize.height,
                        ),
                      ),
                    );
                  } catch (e) {
                    return const Text("Fehler");
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          widget.isLast
              ? Visibility(
                  visible: shouldShowParticles,
                  child: ClipOval(
                    child: CircularParticle(
                      key: UniqueKey(),
                      awayRadius: 2,
                      numberOfParticles: 7000,
                      speedOfParticles: 0.5,
                      height: widget.doorSize.height,
                      width: widget.doorSize.width,
                      onTapAnimation: false,
                      particleColor: const Color(0xFFE0AA3E),
                      awayAnimationDuration: const Duration(seconds: 1),
                      maxParticleSize: 0.15,
                      isRandSize: true,
                      isRandomColor: true,
                      randColorList: const [
                        Color(0xFFD4AF37),
                        Color(0xFFF7EF8A),
                        Color(0xFFc0c0c0),
                      ],
                      awayAnimationCurve: Curves.easeInOutBack,
                      enableHover: false,
                      hoverColor: Colors.white,
                      hoverRadius: 90,
                      connectDots: false, //not recommended
                    ),
                  ),
                )
              : Container(),
          PlainDoor(
            animSec: 1,
            func: (bool check, AnimationController? ct) async {
              if (ct == null) return;
              if (ct.isAnimating) return;
              // if (ct.isCompleted) {
              //   ct.reverse();
              //   return;
              // }
              ct.forward();
              return;
            },
            size: widget.doorSize,
            imgSrc: widget.imgSrc,
            day: widget.day,
            isOpen: widget.isDoorOpen,
            calendar: widget.calendar,
            iterator: widget.iterator,
          ),
        ],
      ),
    );
  }
}
