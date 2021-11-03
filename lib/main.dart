import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';
import 'package:flutter_advent_calender/widgets/plain_door.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adventskalender"),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Stack(
            children: [
              Center(
                child: Container(
                  child: Image.asset("assets/wall.png"),
                ),
              ),
              CalendarDoor(),
            ],
          ),
        ),
      ),
    );
  }
}

// class Main extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Animation & Matrix444"),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Floor(
//                 animSec: 1,
//                 wallImageSrc: "/assets/wall.png",
//                 doorImageSrc: "assets/door.png",
//                 doorPosition: DoorPosition(bottom: 0, right: 20),
//                 wallSize: Size(0, MediaQuery.of(context).size.height * 0.30),
//                 doorSize: Size(170, 250),
//               ),
//               // Floor(
//               //   animSec: 2,
//               //   wallImageSrc:
//               //       "https://cdn.pixabay.com/photo/2012/03/03/23/06/wall-21534__340.jpg",
//               //   doorImageSrc:
//               //       "https://cdn.pixabay.com/photo/2014/12/21/23/45/door-575979__480.png",
//               //   doorPosition: DoorPosition(bottom: 0, left: 50),
//               //   wallSize: Size(0, MediaQuery.of(context).size.height * 0.30),
//               //   doorSize: Size(125, 250),
//               // ),
//               // Floor(
//               //   animSec: 1,
//               //   wallImageSrc:
//               //       "https://cdn.pixabay.com/photo/2015/12/26/05/53/wood-1108307__340.jpg",
//               //   doorImageSrc:
//               //       "https://cdn.pixabay.com/photo/2014/12/21/23/55/door-576355__340.png",
//               //   doorPosition: DoorPosition(bottom: 0, right: 20),
//               //   wallSize: Size(0, MediaQuery.of(context).size.height * 0.30),
//               //   doorSize: Size(170, 250),
//               // ),
//               // Floor(
//               //   animSec: 2,
//               //   wallImageSrc:
//               //       "https://cdn.pixabay.com/photo/2012/03/03/23/06/wall-21534__340.jpg",
//               //   doorImageSrc:
//               //       "https://cdn.pixabay.com/photo/2014/12/21/23/45/door-575979__480.png",
//               //   doorPosition: DoorPosition(bottom: 0, left: 50),
//               //   wallSize: Size(0, MediaQuery.of(context).size.height * 0.30),
//               //   doorSize: Size(125, 250),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DoorPosition {
//   final double? top;
//   final double? bottom;
//   final double? left;
//   final double? right;
//   const DoorPosition({this.top, this.bottom, this.left, this.right});
// }
//
// class Floor extends StatelessWidget {
//   final Size wallSize;
//   final Size doorSize;
//   final String wallImageSrc;
//   final String doorImageSrc;
//   final DoorPosition doorPosition;
//   final int animSec;
//   const Floor({
//     required this.wallImageSrc,
//     required this.doorImageSrc,
//     required this.wallSize,
//     required this.doorSize,
//     required this.doorPosition,
//     required this.animSec,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: this.wallSize.height,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   fit: BoxFit.cover, image: AssetImage(this.wallImageSrc))),
//         ),
//         Positioned(
//           bottom: this.doorPosition.bottom,
//           right: this.doorPosition.right,
//           left: this.doorPosition.left,
//           top: this.doorPosition.top,
//           child: Door(
//             isShadow: true,
//             size: this.doorSize,
//             imgSrc: this.doorImageSrc,
//           ),
//         ),
//         Positioned(
//           bottom: this.doorPosition.bottom,
//           right: this.doorPosition.right,
//           left: this.doorPosition.left,
//           top: this.doorPosition.top,
//           child: Door(
//             animSec: this.animSec,
//             func: (bool check, AnimationController? ct) async {
//               if (ct == null) return;
//               if (ct.isAnimating) return;
//               if (ct.isCompleted) {
//                 ct.reverse();
//                 return;
//               }
//               ct.forward();
//               return;
//             },
//             size: this.doorSize,
//             imgSrc: this.doorImageSrc,
//           ),
//         )
//       ],
//     );
//   }
// }
//
