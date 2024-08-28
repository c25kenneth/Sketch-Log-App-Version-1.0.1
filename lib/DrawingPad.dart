import 'package:canvas_vault/AddImage.dart';
import 'package:canvas_vault/ErrorScreen.dart';
import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/HomeScreen.dart';
import 'package:canvas_vault/LoadingScreen.dart';
import 'package:canvas_vault/components/ImageCarousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawingPad extends StatefulWidget {
  final String sketchbookID;
  final String sketchbookTitle; 
  const DrawingPad({super.key, required this.sketchbookID, required this.sketchbookTitle});

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        DocumentSnapshot notesDoc = await getNotesJson(widget.sketchbookID);
        _controller.document = Document.fromJson(notesDoc.get('notes'));
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                        content: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize
                                    .min, 
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/undraw_blank_canvas_re_2hwy.svg",
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.height *
                                        0.15,
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  const Text(
                                    "Internal Error. Please try again later.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  TextButton(
                                    child: const Text("OK", style: TextStyle(color: Colors.orange),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).then((val) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        uid: FirebaseAuth.instance.currentUser!.uid)),
                (Route<dynamic> route) => false);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      updateSketchbookNotes(
          widget.sketchbookID, _controller.document.toDelta().toJson());
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                surfaceTintColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                content: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize
                            .min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/undraw_blank_canvas_re_2hwy.svg",
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.height * 0.15,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          const Text(
                            "Error saving notes. Please try again later",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            child: const Text("OK", style: TextStyle(color: Colors.orange),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(uid: FirebaseAuth.instance.currentUser!.uid)),
              (Route<dynamic> route) => false);
        });
      });
    }

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sketchbooks")
            .doc(widget.sketchbookID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                     widget.sketchbookTitle,
                    style: GoogleFonts.aBeeZee(),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          try {
                            updateSketchbookNotes(widget.sketchbookID,
                                _controller.document.toDelta().toJson());
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
              
                              content: Center(child: Text("Sketchbook saved!")),
                            ));
                          } catch (e) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      surfaceTintColor: Colors.transparent,
                                      contentPadding: EdgeInsets.zero,
                                      insetPadding:
                                          const EdgeInsets.symmetric(horizontal: 40),
                                      content: SingleChildScrollView(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize
                                                  .min, 
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/undraw_blank_canvas_re_2hwy.svg",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                ),
                                                const SizedBox(
                                                  height: 35,
                                                ),
                                                const Text(
                                                  "Error saving notes. Please try again later",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 20),
                                                TextButton(
                                                  child: const Text("OK", style: TextStyle(color: Colors.orange),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).then((val) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid)),
                                    (Route<dynamic> route) => false);
                              });
                            });
                          }
                        },
                        child: Text("Save",
                            style: GoogleFonts.aBeeZee(
                              color: const Color.fromRGBO(3, 201, 169, 0.7),
                            )))
                  ],
                ),
                body: Container(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomCarouselFB2(
                          sketchbookID: widget.sketchbookID,
                          cards: [
                            ...snapshot.data!.get('imageList').map((imageUrl) {
                              return CardFb1(
                                sketchbookID: widget.sketchbookID,
                                imageUrl: imageUrl,
                                isNetworkImage: true,
                                onPressed: () {},
                              );
                            }).toList(),
                            CardFb1(
                              sketchbookID: widget.sketchbookID,
                              imageUrl:
                                  "",
                              isNetworkImage:
                                  false,
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (ctx) => AddImage(
                                    sketchbookID: widget.sketchbookID,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _controller,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Container(
                          child: QuillToolbar.simple(
                            configurations: QuillSimpleToolbarConfigurations(
                              controller: _controller,
                              multiRowsDisplay: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else {
            return const ErrorScreen();
          }
        });
  }
}
