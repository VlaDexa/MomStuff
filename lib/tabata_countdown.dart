import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

class TabataCountdownPage extends StatefulWidget {
  const TabataCountdownPage({
    super.key,
    required this.title,
    required this.work,
    required this.cycles,
    required this.rest,
    required this.rounds,
  });

  final String title;
  final int work;
  final int rest;
  final int rounds;
  final int cycles;

  @override
  State<TabataCountdownPage> createState() =>
      // ignore: no_logic_in_create_state
      _TabataCountdownState(work, rest, rounds, cycles);
}

enum TabatoState { working, resting }

class _TabataCountdownState extends State<TabataCountdownPage> {
  final int _initialWork;
  final int _initialRest;
  final int _initialRounds;
  int _cycles;
  TabatoState _state = TabatoState.working;
  int _work;
  int _rest;
  int _rounds;
  bool stopped = false;
  late Timer _timer;
  late BuildContext _context;
  static final AudioPlayer _beepPlayer = AudioPlayer();
  static final AudioPlayer _musicPlayer = AudioPlayer();
  static const String beepUrl = "audio/beep.mp3";

  _TabataCountdownState(int work, int rest, int rounds, int cycles)
      : _cycles = cycles,
        _initialRest = rest,
        _rest = rest,
        _initialRounds = rounds,
        _rounds = rounds,
        _initialWork = work,
        _work = work {
    _timer = setWorkTimer();
    _beepPlayer.setSourceAsset(beepUrl);
    _musicPlayer.play(UrlSource(
        "https://srv21.gpmradio.ru:8443/stream/air/aac/64/99?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJrZXkiOiI3Njk1MGRmYWY5YjA1MTQ4MzdkNmE4MjNmMmIxZTRkZSIsIklQIjoiODkuMTkuMTc0LjE4MSIsIlVBIjoiTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NDsgcnY6MTA5LjApIEdlY2tvLzIwMTAwMTAxIEZpcmVmb3gvMTE0LjAiLCJSZWYiOiJodHRwczovL3d3dy5lbmVyZ3lmbS5ydS8iLCJ1aWRfY2hhbm5lbCI6Ijk5IiwidHlwZV9jaGFubmVsIjoiY2hhbm5lbCIsInR5cGVEZXZpY2UiOiJQQyIsIkJyb3dzZXIiOiJGaXJlZm94IiwiQnJvd3NlclZlcnNpb24iOiIxMTQuMCIsIlN5c3RlbSI6IldpbmRvd3MgMTAiLCJleHAiOjE2ODcxMTc1MTF9.PV2dPIxsNc0R0zxkpFlW5uZS5fILyiBaDJbeZHgfX-Q"));
  }

  Timer setWorkTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (stopped) return;
      setState(() {
        _work--;
      });
      if (_work <= 0) {
        timer.cancel();
        setState(() {
          _work = _initialWork;
          _state = TabatoState.resting;
        });
        _timer = setRestTimer();
      }
    });
  }

  Timer setRestTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (stopped) return;
      setState(() {
        _rest--;
      });
      if (_rest <= 0) {
        timer.cancel();
        setState(() {
          _rest = _initialRest;
          _state = TabatoState.working;
          _rounds--;
        });
        if (_rounds <= 0) {
          setState(() {
            _rounds = _initialRounds;
            _cycles--;
          });
        }
        if (_cycles <= 0) {
          Navigator.pop(_context);
        }
        _timer = setWorkTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    String workMinutes = (_work / 60).floor().toString().padLeft(2, '0');
    String workSeconds = (_work % 60).toString().padLeft(2, '0');

    String restMinutes = (_rest / 60).floor().toString().padLeft(2, '0');
    String restSeconds = (_rest % 60).toString().padLeft(2, '0');

    String text = _state == TabatoState.working ? "Работаем" : "Отдыхаем";
    String countdown = _state == TabatoState.working
        ? "$workMinutes:$workSeconds"
        : "$restMinutes:$restSeconds";

    if (_rest <= 3 || _work <= 3) {
      _beepPlayer.stop();
      _beepPlayer.play(AssetSource(beepUrl));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Цикл $_cycles"),
            Text("Раунд $_rounds"),
            Text(text),
            Text(countdown),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Сбросить"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            stopped = !stopped;
          });
        },
        child: Icon(stopped ? Icons.play_arrow : Icons.pause),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _musicPlayer.stop();
    _beepPlayer.stop();
    super.dispose();
  }
}
