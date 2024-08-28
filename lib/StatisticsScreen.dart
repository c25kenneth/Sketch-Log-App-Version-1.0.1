import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/LoadingScreen.dart';
import 'package:canvas_vault/StopwatchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsScreen extends StatefulWidget {
  final String sketchbookID;

  const StatisticsScreen({super.key, required this.sketchbookID});
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool timerIsActive = false;
  bool isPaused = false;

  DateTime startTime = DateTime.now();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _modalController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); 
    _modalController.dispose(); 
    super.dispose();
  }
  String formatDuration(int totalSeconds) {
    Duration duration = Duration(seconds: totalSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String hoursStr = hours > 0 ? '$hours' : '0';
    String minutesStr = minutes > 0 || hours > 0 ? '${minutes}' : '0';
    String secondsStr = '${twoDigits(seconds)}';

    return hoursStr + "h " + minutesStr + "m " + secondsStr + "s";
  }

  String formatDurationNoSeconds(int totalSeconds) {
    Duration duration = Duration(seconds: totalSeconds);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    String hoursStr = '$hours' + 'h ';
    String minutesStr = '${minutes}m ';

    return hoursStr + minutesStr;
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (timerIsActive || !isPaused) ? false : true,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('sketchbooks')
              .doc(widget.sketchbookID)
              .collection('sessions')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('sketchbooks')
                      .doc(widget.sketchbookID)
                      .collection('sessions')
                      .where('status', isEqualTo: "complete")
                      .snapshots(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      var documents = snapshot2.data!.docs;

                      documents.sort((a, b) {
                        Timestamp aTime = a.data()['time'] ?? Timestamp(0, 0);
                        Timestamp bTime = b.data()['time'] ?? Timestamp(0, 1);
                        return bTime.compareTo(aTime);
                      });

                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('sketchbooks')
                              .doc(widget.sketchbookID)
                              .snapshots(),
                          builder: (context, snapshot3) {
                            if (snapshot3.hasData) {
                              return Scaffold(
                                resizeToAvoidBottomInset: false,
                                backgroundColor: Colors
                                    .orange, 
                                body: Stack(
                                  children: [
                                    Container(
                                      color: Colors.orange,
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.85, 
                                        decoration: const BoxDecoration(
                                          color: Colors
                                              .white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                          ),
                                        ),
                                        child:
                                            (timerIsActive &&
                                                    snapshot.data!.docs
                                                        .where((element) =>
                                                            element.get(
                                                                'status') ==
                                                            'incomplete')
                                                        .toList()
                                                        .isNotEmpty)
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 25),
                                                        StopwatchPage(
                                                          addBackFunc: () {
                                                            setState(() {
                                                              isPaused = true;
                                                            });
                                                          },
                                                          removeBackFunc: () {
                                                            setState(() {
                                                              timerIsActive =
                                                                  true;
                                                              isPaused = false;
                                                            });
                                                          },
                                                          sketchbookID: widget
                                                              .sketchbookID,
                                                          sessionID: snapshot
                                                              .data!.docs
                                                              .where((element) =>
                                                                  element.get(
                                                                      'status') ==
                                                                  'incomplete')
                                                              .toList()[0]
                                                              .id,
                                                          initialTitle: snapshot
                                                              .data!.docs
                                                              .where((element) =>
                                                                  element.get(
                                                                      'status') ==
                                                                  'incomplete')
                                                              .toList()[0]
                                                              .get(
                                                                  'sessionTitle'),
                                                          onBackPressed: () {
                                                            setState(() {
                                                              timerIsActive =
                                                                  false;
                                                              isPaused = true;
                                                            });
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            formatDurationNoSeconds(
                                                                snapshot3.data!.get(
                                                                    'elapsedTime')),
                                                            style: GoogleFonts
                                                                .aBeeZee(
                                                                    fontSize:
                                                                        30),            
                                                          ),
                                                          Text(
                                                            "Total Time Spent Drawing this Idea",
                                                            style: GoogleFonts
                                                                .aBeeZee(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.04),
                                                          Text(
                                                            "Current work session",
                                                            style: GoogleFonts
                                                                .aBeeZee(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        24),
                                                          ),
                                                          (snapshot.data!.docs
                                                                      .isEmpty ||
                                                                  snapshot.data!
                                                                      .docs
                                                                      .where((element) =>
                                                                          element
                                                                              .get('status') ==
                                                                          'incomplete')
                                                                      .isEmpty)
                                                              ? Container(
                                                                  margin: EdgeInsets.only(
                                                                      top: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.05),
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          "assets/images/undraw_time_management_re_tk5w.svg",
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.15,
                                                                          width:
                                                                              MediaQuery.of(context).size.height * 0.15,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                15),
                                                                        RichText(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                'You currently have no work sessions.\n \n',
                                                                            style: GoogleFonts.aBeeZee(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: Colors.black),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                  text: 'Start one now',
                                                                                  style: const TextStyle(fontSize: 18, color: Colors.orange),
                                                                                  recognizer: TapGestureRecognizer()
                                                                                    ..onTap = () async {
                                                                                      DateTime now = DateTime.now();
                                                                                      _controller.text = _controller.text = DateFormat('yyyy-MM-dd hh:mm a').format(now);
                                                                                      await createSession(widget.sketchbookID, _controller.text, now);
                                                                                    }),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                12),
                                                                    itemCount: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .where((element) =>
                                                                            element.get('status') ==
                                                                            'incomplete')
                                                                        .toList()
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(
                                                                              color: Colors.grey, 
                                                                              width: 0.5, 
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child: Dismissible(
                                                                          background:
                                                                              Container(
                                                                            color:
                                                                                Colors.red,
                                                                            padding:
                                                                                const EdgeInsets.only(right: 20.0),
                                                                            child:
                                                                                const Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: <Widget>[
                                                                                Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                SizedBox(width: 15,),
                                                                                Text("Delete", style: TextStyle(color: Colors.white)),
                                                                                
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          key: ValueKey(snapshot
                                                                        .data!
                                                                        .docs
                                                                        .where((element) =>
                                                                            element.get('status') ==
                                                                            'incomplete')
                                                                        .toList()[0].id),
                                                                        direction: DismissDirection.endToStart,
                                                                          onDismissed: (direction) async {
                                                                            await deleteSessionIncomplete(widget.sketchbookID, snapshot
                                                                        .data!
                                                                        .docs
                                                                        .where((element) =>
                                                                            element.get('status') ==
                                                                            'incomplete')
                                                                        .toList()[0].id);
                                                                          },
                                                                          child: ListTile(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                timerIsActive = !timerIsActive;
                                                                                _controller.text = snapshot.data!.docs.where((element) => element.get('status') == 'incomplete').toList()[index].get('sessionTitle');
                                                                                startTime = DateTime.now();
                                                                                isPaused = true;
                                                                              });
                                                                            },
                                                                            title:
                                                                                Text(
                                                                              snapshot.data!.docs.where((element) => element.get('status') == 'incomplete').toList()[index].get('sessionTitle'),
                                                                              style:
                                                                                  GoogleFonts.aBeeZee(fontSize: 17),
                                                                            ),
                                                                            trailing:
                                                                                const Icon(Icons.chevron_right),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                          (snapshot.data!.docs
                                                                      .isNotEmpty &&
                                                                  snapshot.data!
                                                                      .docs
                                                                      .where((element) =>
                                                                          element
                                                                              .get('status') ==
                                                                          'complete')
                                                                      .toList()
                                                                      .isNotEmpty)
                                                              ? Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    Text(
                                                                      "Past Sessions",
                                                                      style: GoogleFonts.aBeeZee(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              24),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                          (snapshot.data!.docs
                                                                      .isNotEmpty &&
                                                                  documents
                                                                      .isNotEmpty)
                                                              ? Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                12),
                                                                    itemCount: documents
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(
                                                                              color: Colors.grey, 
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Dismissible(
                                                                              direction: DismissDirection.endToStart,
                                                                              key: ValueKey(documents[index].id),
                                                                          onDismissed:
                                                                              (direction) async {
                                                                                await deleteSession(widget.sketchbookID, documents[index].get('elapsedTime'), documents[index].id);
                                                                              },
                                                                          background:
                                                                              Container(
                                                                            color:
                                                                                Colors.red,
                                                                            padding:
                                                                                const EdgeInsets.only(right: 20.0),
                                                                            child:
                                                                                const Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: <Widget>[
                                                                                Icon(
                                                                                  Icons.delete,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                SizedBox(width: 15,),
                                                                                Text("Delete", style: TextStyle(color: Colors.white)),
                                                                                
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              String initialText = documents[index].get("sessionTitle");
                                                                              _modalController.text = documents[index].get("sessionTitle");
                                                                              bool _isEnable = false;
                                                                              bool _hasTextChanged = false;
                                                                              showModalBottomSheet(
                                                                                  backgroundColor: Colors.white,
                                                                                  context: context,
                                                                                  isScrollControlled: true,
                                                                                  builder: (context) {
                                                                                    return StatefulBuilder(
                                                                                      builder: (BuildContext context, StateSetter setState) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                            bottom: MediaQuery.of(context).viewInsets.bottom,
                                                                                          ),
                                                                                          child: Wrap(
                                                                                            children: [
                                                                                              Container(
                                                                                                padding: const EdgeInsets.all(30),
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Row(
                                                                                                      children: <Widget>[
                                                                                                        Expanded(
                                                                                                          child: TextField(
                                                                                                            onChanged: (text) {
                                                                                                              setState(() {
                                                                                                                _hasTextChanged = text != initialText;
                                                                                                              });
                                                                                                            },
                                                                                                            style: const TextStyle(
                                                                                                              fontSize: 22,
                                                                                                            ),
                                                                                                            controller: _modalController,
                                                                                                            enabled: _isEnable,
                                                                                                          ),
                                                                                                        ),
                                                                                                        IconButton(
                                                                                                          icon: const Icon(Icons.edit),
                                                                                                          onPressed: () {
                                                                                                            setState(() {
                                                                                                              _isEnable = !_isEnable;
                                                                                                            });
                                                                                                          },
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(height: 10),
                                                                                                    Text(
                                                                                                      "Created on " + DateFormat('MM/dd/yyyy \'at\' hh:mm a').format(documents[index].data()["time"].toDate()),
                                                                                                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                                                                                    ),
                                                                                                    const SizedBox(height: 25),
                                                                                                    Text(
                                                                                                      'You worked for',
                                                                                                      style: GoogleFonts.aBeeZee(fontSize: 20),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      formatDuration(documents[index].get("elapsedTime")),
                                                                                                      style: GoogleFonts.aBeeZee(fontSize: 28),
                                                                                                    ),
                                                                                                    SizedBox(height: 15),
                                                                                                    if (_hasTextChanged)
                                                                                                      Center(
                                                                                                        child: CupertinoButton(
                                                                                                          onPressed: () async {
                                                                                                            await updateSessionTitle(widget.sketchbookID, documents[index].id, _modalController.text);
                                                                                                            Navigator.of(context).pop();
                                                                                                          },
                                                                                                          child: const Text(
                                                                                                            "Save",
                                                                                                            style: TextStyle(fontSize: 22, color: Colors.orange),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  });
                                                                            },
                                                                            title:
                                                                                Text(
                                                                              documents[index].get("sessionTitle"),
                                                                              style: GoogleFonts.aBeeZee(fontSize: 17),
                                                                            ),
                                                                            trailing:
                                                                                const Icon(Icons.chevron_right),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                                  0.85 +
                                              5,
                                      child: !timerIsActive || isPaused
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (!timerIsActive) {
                                                      Navigator.pop(
                                                          context);
                                                    } else {
                                                      setState(() {
                                                        timerIsActive =
                                                            !timerIsActive;
                                                        isPaused = true;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_back_outlined,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  child: Text(
                                                    "Sketchbook Productivity",
                                                    style: GoogleFonts.aBeeZee(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const LoadingScreen();
                            }
                          });
                    } else {
                      return const LoadingScreen();
                    }
                  });
            } else {
              return const LoadingScreen();
            }
          }),
    );
  }
}
