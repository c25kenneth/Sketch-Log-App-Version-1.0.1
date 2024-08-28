
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBarFb2Small extends StatelessWidget {
  final String title;
  final String upperTitle;
  const TopBarFb2Small({required this.title, required this.upperTitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(title,
              style: GoogleFonts.aBeeZee(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.normal)),
          Text(upperTitle,
              style: GoogleFonts.aBeeZee(
                  color: const Color.fromRGBO(247, 204, 62, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold))
        ],
    );
  }
}
