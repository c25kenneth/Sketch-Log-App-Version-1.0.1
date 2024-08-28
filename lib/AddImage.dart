import 'dart:io';

import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  final String sketchbookID; 
  const AddImage({super.key, required this.sketchbookID});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool _clicked = false; 

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: screenHeight * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Image to Sketchbook',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 25),
            (image != null)
                ? Center(
                    child: GestureDetector(
                      onTap: () async {
                        await pickImage();
                      },
                      child: Container(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.5,
                        child: Center(
                          child: Image.file(
                            image!,
                            height: screenHeight * 0.35,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20),
                      dashPattern: const [10, 10],
                      color: Colors.grey,
                      strokeWidth: 2,
                      child: InkWell(
                        onTap: () async {
                          await pickImage(); 
                        },
                        child: Container(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.4,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 56,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "Select an image to upload!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 25),

            (image != null)
                ? SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.4,
                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      20),
                              backgroundColor: Colors
                                  .orange, 
                              foregroundColor:
                                  Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), 
                              ),
                            ),
                            onPressed: _clicked == false ? () async {
                              setState(() {
                                _clicked = true; 
                              });
                              dynamic res = await addImage(widget.sketchbookID, image!);
                              if (res.runtimeType != String) {
                                await showDialog(
                                context: navigatorKey.currentContext!,
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
                                });
                              } 
                              Navigator.of(context).pop();
                              setState(() {
                                _clicked = false;
                              });
                            } : null,
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: screenWidth * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      20), 
                              backgroundColor: Colors
                                  .white,
                              foregroundColor:
                                  Colors.orange, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), 
                                side: const BorderSide(
                                    color: Colors.orange,
                                    width: 2), 
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
