import 'package:canvas_vault/ErrorScreen.dart';
import 'package:canvas_vault/LoadingScreen.dart';
import 'package:canvas_vault/components/NotebookTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllSketchbooks extends StatefulWidget {
  final String uid;
  const AllSketchbooks({super.key, required this.uid});

  @override
  State<AllSketchbooks> createState() => _AllSketchbooksState();
}

class _AllSketchbooksState extends State<AllSketchbooks> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(widget.uid).collection("sketchbooks").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("All Sketchbooks", style: GoogleFonts.aBeeZee(fontSize: 28),),),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: NotebookTile(title: snapshot.data!.docs[index].get('sketchbookTitle'), description: snapshot.data!.docs[index].get("sketchbookDescription"), sketchbookID: snapshot.data!.docs[index].id),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          return const ErrorScreen(); 
        }
      }
    );
  }
}