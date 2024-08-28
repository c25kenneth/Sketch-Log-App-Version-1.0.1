import 'package:canvas_vault/FirestoreFuncs.dart';
import 'package:canvas_vault/HomeScreen.dart';
import 'package:canvas_vault/components/AppleSignInButton.dart';
import 'package:canvas_vault/components/GoogleSignInButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final String assetName = 'assets/images/Logo.png';
  String errorString = "";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: width * 0.55,
            height: height * 0.30,
            child: Image.asset(
              assetName,
            ),
          ),
          const Text(
            "Sketch Log",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.orange),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Capture your artistic ideas, set reminders, and bring your imagination to life - all in one place.',
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w400, fontSize: 18),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          GoogleBtn1(onPressed: () async {
            dynamic credGoogle = await signInWithGoogle();

            if (credGoogle.runtimeType != String) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            uid: credGoogle.user!.uid,
                          )),
                  (route) => false);
            } else {
              setState(() {
                errorString = "Please try again";
              });
            }
          }),
          AppleBtn1(onPressed: () async {
            dynamic credApple = await signInWithApple();

            if (credApple.runtimeType != String) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            uid: credApple.user!.uid,
                          )),
                  (route) => false);
            } else {
              setState(() {
                errorString = "Please Try Again";
              });
            }
          }),
          SizedBox(height: 15),
          Center(
              child: (errorString != "")
                  ? Text(
                      errorString,
                      style: const TextStyle(fontSize: 17, color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(height: 15)),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:"By continuing you agree to Sketch Log's ",
                style: GoogleFonts.aBeeZee(
                    fontSize: 15,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Terms & Conditions ',
                      style: const TextStyle(fontSize: 15, color: Colors.orange),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        try {
                          var url = Uri.https('getsketchlog.com', '/terms-of-service');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        } catch (e) {
                          setState(() {
                            errorString = "Can't open URL. Please try again later!";
                          });
                        }
                      }),
                      TextSpan(
                      text: 'and ',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      TextSpan(
                      text: 'Privacy Policy. ',
                      style: const TextStyle(fontSize: 15, color: Colors.orange),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        try {
                          var url = Uri.https('www.termsfeed.com', '/live/01e3ee3e-fe26-479e-9d10-3690dea9310c');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        } catch (e) {
                          setState(() {
                            errorString = "Can't open url. Please try again later!";
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 15,
          // ),
        ]),
      ),
    );
  }
}
