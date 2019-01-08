import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locale_scoreboard/helpers/controller_data.dart';

class TimerValues {
  final TimerState timerState;
  final int time;

  TimerValues(this.timerState, this.time);
}

enum TimerState { start, cancel, reset, setTime }

class SetTime extends StatefulWidget {
  final Stream<ControllerData> timeStream;
  final ValueChanged<int> onTimeChange;

  const SetTime({Key key, this.timeStream, this.onTimeChange})
      : super(key: key);
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  Timer _timer;
  int _elapsedTimeSeconds = 0;
  int _elapsedTimeMinutes = 0;
  String _elapsedTimeSecondsFormatted = "00";
  String _elapsedTimeMinutesFormatted = "00";
  int _elapsedTime = 0;
  @override
  void initState() {
    super.initState();

    widget.timeStream.listen((ControllerData item) {
      if (item.type == ControllerType.time) {
        switch (item.data.timerState) {
          case TimerState.start:
            _elapsedTime = item.data.time;
            if (_timer == null) {
              _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
                _elapsedTime += 1;
                formatTime();
                if (widget.onTimeChange != null) {
                  widget.onTimeChange(_elapsedTime);
                }
              });
            }
            break;
          case TimerState.reset:
            if (_timer != null) {
              if (widget.onTimeChange != null) {
                widget.onTimeChange(_elapsedTime);
              }
              _timer?.cancel();
              _timer = null;
              _elapsedTimeMinutes = 0;
              _elapsedTimeSeconds = 0;
              _elapsedTime = 0;

              setState(() {
                _elapsedTimeSecondsFormatted = "00";
                _elapsedTimeMinutesFormatted = "00";
              });
            }
            break;
          case TimerState.cancel:
            if (widget.onTimeChange != null) {
              widget.onTimeChange(_elapsedTime);
            }
            if (_timer != null) {
              _timer?.cancel();
              _timer = null;
            }
            break;
          case TimerState.setTime:
            break;
        }
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

  void formatTime() {
    setState(() {
      if (_elapsedTime > 59) {
        _elapsedTimeMinutes = (_elapsedTime / 60).floor();
        _elapsedTimeSeconds = (_elapsedTime % 60).floor();
        _elapsedTimeMinutesFormatted = _elapsedTimeMinutes < 10
            ? "0${_elapsedTimeMinutes.toString()}"
            : _elapsedTimeMinutes.toString();
        _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
            ? "0${_elapsedTimeSeconds.toString()}"
            : _elapsedTimeSeconds.toString();
      } else {
        _elapsedTimeSeconds = _elapsedTime;
        _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
            ? "0${_elapsedTimeSeconds.toString()}"
            : _elapsedTimeSeconds.toString();
      }
    });
  }
}
