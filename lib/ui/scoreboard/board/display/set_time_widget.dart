import 'dart:async';

import 'package:flutter/material.dart';

enum TimerState { start, cancel, reset }

class SetTime extends StatefulWidget {
  final Stream<TimerState> timeStream;

  const SetTime({Key key, this.timeStream}) : super(key: key);
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  Timer _timer;
  int _elapsedTimeSeconds = 0;
  int _elapsedTimeMinutes = 0;
  String _elapsedTimeSecondsFormatted = "00";
  String _elapsedTimeMinutesFormatted = "00";

  @override
  void initState() {
    super.initState();
    widget.timeStream.listen((TimerState state) {
      switch (state) {
        case TimerState.start:
          if (_timer != null && !_timer.isActive) {
            _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
              setState(() {
                if (timer.tick > 59) {
                  _elapsedTimeMinutes = (timer.tick / 60).floor();
                  _elapsedTimeSeconds = (timer.tick % 60).floor();
                  _elapsedTimeMinutesFormatted = _elapsedTimeMinutes < 10
                      ? "0${_elapsedTimeMinutes.toString()}"
                      : _elapsedTimeMinutes.toString();
                  _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
                      ? "0${_elapsedTimeSeconds.toString()}"
                      : _elapsedTimeSeconds.toString();
                } else {
                  _elapsedTimeSeconds = timer.tick;
                  _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
                      ? "0${_elapsedTimeSeconds.toString()}"
                      : _elapsedTimeSeconds.toString();
                }
              });
            });
          }
          break;
        case TimerState.reset:
          if (_timer != null && _timer.isActive) {
            _timer?.cancel();
            _timer = null;
            _elapsedTimeMinutes = 0;
            _elapsedTimeSeconds = 0;

            setState(() {
              _elapsedTimeSecondsFormatted = "00";
              _elapsedTimeMinutesFormatted = "00";
            });
          }
          break;
        case TimerState.cancel:
          if (_timer != null && _timer.isActive) {
            _timer?.cancel();
            _timer = null;
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(Icons.timer, color: Colors.white, size: 16),
          ),
          Text("$_elapsedTimeMinutesFormatted:$_elapsedTimeSecondsFormatted",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 1.0)),
    );
  }
}
