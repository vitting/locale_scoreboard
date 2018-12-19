import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class TestWidget extends StatefulWidget {
  static final routeName = "/test";
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  FlutterTts flutterTts = new FlutterTts();
  Stopwatch stopwatch = Stopwatch();
  Timer timer;
  int elapsedIime = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Test"),
              onPressed: () async {
                List<dynamic> languages = await flutterTts.getLanguages;
                print(languages);
                await flutterTts.setLanguage("en-US");
                await flutterTts.setSpeechRate(0.5);
                await flutterTts.setVolume(1.0);
                await flutterTts.setPitch(1.0);
                await flutterTts.isLanguageAvailable("en-US");

                var result = await flutterTts
                    .speak("Team A 25 points and Team B 21 points");
              },
            ),
            RaisedButton(
              child: Text("Start"),
              onPressed: () async {
                stopwatch.start();

                if (stopwatch.isRunning) {
                  timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                    setState(() {
                      elapsedIime = stopwatch.elapsedMilliseconds;
                    });
                  });
                }
              },
            ),
            RaisedButton(
              child: Text("Start2"),
              onPressed: () async {
                timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                  setState(() {
                    elapsedIime = t.tick;
                  });
                });
              },
            ),
            RaisedButton(
              child: Text("Stop"),
              onPressed: () async {
                timer.cancel();
                stopwatch.stop();
              },
            ),
            Text(elapsedIime.toString())
          ],
        ),
      ),
    );
  }
}
