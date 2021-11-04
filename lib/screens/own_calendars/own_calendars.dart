import 'package:flutter/material.dart';

class OwnCalendars extends StatefulWidget {
  const OwnCalendars({Key? key}) : super(key: key);

  @override
  _OwnCalendarsState createState() => _OwnCalendarsState();
}

class _OwnCalendarsState extends State<OwnCalendars>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
