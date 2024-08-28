import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/components/CustomTextField.dart';
import 'package:canvas_vault/components/GradientButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSketchbook extends StatefulWidget {
  const AddSketchbook({super.key});

  @override
  State<AddSketchbook> createState() => _AddSketchbookState();
}

class _AddSketchbookState extends State<AddSketchbook> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String errorString = ""; 

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

    return GestureDetector(
      onTap: () {
         FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create a Sketchbook"),
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
                const Text("Sketchbook Description", style: TextStyle(fontSize: 19)),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: _descriptionController,
                  name: "Sketchbook for personal fanart",
                  inputType: TextInputType.multiline,
                  numLines: 2,
                  maxLen: 120,
                ),
                SizedBox(height: screenHeight * 0.28),
                // Spacer(),
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    child: GradientButtonFb1(
                      text: "Create Sketchbook",
                      onPressed: () async {
                        if (_titleController.text != "" && _descriptionController != "" ) {
                          dynamic res = await createSketchbook(FirebaseAuth.instance.currentUser!.uid, _titleController.text, _descriptionController.text);
                          if (res.runtimeType == String) {
                            Navigator.of(context).pop();
                          } else {
                            errorString = "Internal error. Please try again later!";
                          }
                        } else {
                          setState(() {
                            errorString = "Sketchbook title and description are required!";
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Center(child: (errorString != "") ? Text(errorString, style: const TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,) : SizedBox()),
                const SizedBox(height: 85),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
