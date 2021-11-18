import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/models/ad_state.dart';
import 'package:flutter_advent_calender/models/calendar_model.dart';
import 'package:flutter_advent_calender/services/local_database_handler.dart';
import 'package:flutter_advent_calender/widgets/calendar_door.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CalendarView extends StatefulWidget {
  final CalendarModel calendar;
  const CalendarView({
    Key? key,
    required this.calendar,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DatabaseHandler db = DatabaseHandler();

  late Future<List<Map<String, dynamic>>> _futureOpenList;

  Future<List<Map<String, dynamic>>> getOpenList() async =>
      await db.getOpenDayEntries(widget.calendar.id);

  late BannerAd banner;
  bool isBannerAdReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.calendarViewBottomAd,
          size: AdSize.banner,
          listener: BannerAdListener(
              onAdLoaded: (ad) {
                setState(() {});
                isBannerAdReady = true;
              },
              onAdFailedToLoad: (ad, e) =>
                  print("failed to load ad ${ad.adUnitId} ${e.message}")),
          request: const AdRequest(),
        )..load();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _futureOpenList = getOpenList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calendar.title),
      ),
      body: Stack(
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureOpenList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InteractiveViewer(
                        maxScale: 60,
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                  "assets/background_${widget.calendar.bgId}.jpg"),
                            ),
                            for (int i = 0; i < 24; i++)
                              Positioned(
                                bottom: widget.calendar.bgId != 1
                                    ? bottom[23 - i].toDouble()
                                    : (bottom[23 - i] - 150).toDouble(),
                                right: right[23 - i].toDouble(),
                                child: CalendarDoor(
                                  iterator: i,
                                  imgSrc:
                                      "assets/door_${widget.calendar.doorId}.png",
                                  day: "${i + 1}",
                                  doorSize: const Size(17, 25),
                                  isLast: i == 23,
                                  calendar: widget.calendar,
                                  isDoorOpen: snapshot.data![i]["open"] == 1,
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
          if (isBannerAdReady)
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: SizedBox(
                  height: 50,
                  child: AdWidget(
                    ad: banner,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  List bottom = [
    350,
    350,
    350,
    350,
    350,
    350,
    350,
    350,
    400,
    400,
    400,
    400,
    400,
    400,
    400,
    400,
    450,
    450,
    450,
    450,
    450,
    450,
    450,
    450,
  ];
  List right = [
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
    20,
    70,
    120,
    170,
    220,
    270,
    320,
    370,
  ];
}
