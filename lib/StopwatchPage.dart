import 'dart:async';
import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  final String initialTitle; 
  final String sketchbookID; 
  final String sessionID; 
  final Function? onBackPressed; 
  final Function? removeBackFunc; 
  final Function? addBackFunc; 
  const StopwatchPage({super.key, required this.sketchbookID, required this.sessionID, required this.initialTitle, required this.onBackPressed, required this.removeBackFunc, required this.addBackFunc});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch stopwatch;
  Timer? timer;
  bool _isEnable = false;
  bool isPaused = true;
  String errorString = "";
  bool textHasChanged = false;
  late String previousText; 

  void togglePauseResume() {
  if (stopwatch.isRunning) {
    stopwatch.stop();
    timer?.cancel();
    setState(() {
      isPaused = true;
      errorString = ""; 
    });
    widget.addBackFunc!(); 
  } else {
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    setState(() {
      isPaused = false;
      errorString = ""; 
    });
    widget.removeBackFunc!(); 
  }
}

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      timer?.cancel();
      setState(() {
        isPaused = true;
      });
      widget.addBackFunc!(); 
    } else {
      stopwatch.start();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
      setState(() {
        isPaused = false;
      });
      widget.removeBackFunc!(); 
    }
  }

  void donePressed() async {
    if (stopwatch.elapsed != Duration.zero) {
      stopwatch.stop();
      timer?.cancel();
      setState(() {
        isPaused = true;
        errorString = ""; 
      });
      widget.addBackFunc!(); 
      await updateSessionTime(
          widget.sketchbookID, widget.sessionID, stopwatch.elapsed, _controller.text);
      widget.onBackPressed!();
    } else {
      setState(() {
        errorString = "Timer not started!";
      });
    }
  }

  String returnFormattedText() {
    var elapsed = stopwatch.elapsed;

    String seconds = (elapsed.inSeconds % 60).toString().padLeft(2, "0");
    String minutes = (elapsed.inMinutes % 60).toString().padLeft(2, "0");
    String hours = (elapsed.inHours).toString().padLeft(2, "0");

    if (elapsed.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    previousText = widget.initialTitle;
    _controller.text = widget.initialTitle;
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose(); 
    super.dispose();
  }

  void resetStopwatch() {
    stopwatch.reset();
    stopwatch.stop();
    timer?.cancel();
    setState(() {
      isPaused = true; 
      errorString = ""; 
    });
  }

  final TextEditingController _controller = TextEditingController();

  void handleTextChange(String newText) async {
    await updateSessionTitle(widget.sketchbookID, widget.sessionID, newText);
    setState(() {
      previousText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Title',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: _isEnable,
                  onChanged: (text) {
                    setState(() {
                      textHasChanged = text != previousText;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEnable = !_isEnable;
                    if (_isEnable) {
                      previousText = _controller.text; 
                    } else {
                      if (_controller.text != previousText) {
                        handleTextChange(_controller.text);
                      }
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          Center(
            child: CupertinoButton(
              onPressed: handleStartStop,
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(253, 183, 119, 1),
                    width: 4,
                  ),
                ),
                child: Text(
                  returnFormattedText(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: donePressed,
                padding: const EdgeInsets.all(0),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  size: 32,
                ),
                onPressed: togglePauseResume,
              ),
              CupertinoButton(
                onPressed: resetStopwatch,
                padding: const EdgeInsets.all(0),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Center(
            child: (errorString != "")
                ? Text(
                    errorString,
                    style: const TextStyle(fontSize: 19, color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
