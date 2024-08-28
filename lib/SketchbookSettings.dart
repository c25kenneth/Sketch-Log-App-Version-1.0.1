import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/components/CustomTextField.dart';
import 'package:canvas_vault/components/GradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SketchbookSettings extends StatefulWidget {
  final String sketchbookID;
  final String sketchbookTitle;
  final String sketchbookDescription;
  const SketchbookSettings(
      {super.key,
      required this.sketchbookTitle,
      required this.sketchbookDescription,
      required this.sketchbookID});

  @override
  State<SketchbookSettings> createState() => _SketchbookSettingsState();
}

class _SketchbookSettingsState extends State<SketchbookSettings> {
  bool _clicked = false; 
  String errorString = "";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.sketchbookTitle;
    _descriptionController.text = widget.sketchbookDescription;
  }

  @override
  void dispose() {
    _titleController.dispose(); 
    _descriptionController.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sketchbookTitle,
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sketchbook Title", style: TextStyle(fontSize: 19)),
              const SizedBox(height: 10.0),
              CustomTextField(
                controller: _titleController,
                name: "Awesome Fanart Sketchbook",
                inputType: TextInputType.text,
                maxLen: 32,
                numLines: 1,
              ),
              const SizedBox(height: 15),
              const Text("Sketchbook Description",
                  style: TextStyle(fontSize: 19)),
              const SizedBox(height: 10.0),
              CustomTextField(
                controller: _descriptionController,
                name: "Sketchbook for personal fanart",
                inputType: TextInputType.multiline,
                numLines: 2,
                maxLen: 120,
              ),
              SizedBox(height: screenHeight * 0.15),
              SafeArea(
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    child: GradientButtonFb1(
                      text: "Update Sketchbook",
                      onPressed: () async {
                        if (_titleController.text != "" &&
                            _descriptionController.text != "") {
                          dynamic res = await updateSketchbookSettings(
                              widget.sketchbookID,
                              _titleController.text,
                              _descriptionController.text);
                          if (res.runtimeType == String) {
                            Navigator.of(context).pop();
                          } else {
                            errorString =
                                "Internal error. Please try again later!";
                          }
                        } else {
                          setState(() {
                            errorString =
                                "Sketchbook title and/or description are required!";
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              Center(
                  child: (errorString != "")
                      ? Text(
                          errorString,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox()),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or you can',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: CupertinoButton(
                      onPressed: (_clicked == false) ? () async {
                        setState(() {
                          _clicked = true; 
                        });
                        dynamic res = await deleteSketchbook(FirebaseAuth.instance.currentUser!.uid, widget.sketchbookID);
                        if (res.runtimeType == String) {
                          Navigator.of(context).pop(); 
                        }
                      } : null,
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        "Permanently delete this sketchbook",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
