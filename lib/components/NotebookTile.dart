import 'package:canvas_vault/DrawingPad.dart';
import 'package:canvas_vault/ScheduleReminder.dart';
import 'package:canvas_vault/SketchbookSettings.dart';
import 'package:canvas_vault/StatisticsScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotebookTile extends StatefulWidget {
  final String title;
  final String description;
  final String sketchbookID;
  const NotebookTile(
      {super.key,
      required this.title,
      required this.description,
      required this.sketchbookID});

  @override
  State<NotebookTile> createState() => _NotebookTileState();
}

class _NotebookTileState extends State<NotebookTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DrawingPad(sketchbookID: widget.sketchbookID, sketchbookTitle: widget.title,)));
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: Colors.orange, 
            padding: const EdgeInsets.all(9.0), 
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white, 
            ),
          ),
        ),
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          widget.description,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.aBeeZee(
            fontSize: 14,
          ),
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert_outlined),
          surfaceTintColor: Colors.white,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "Analytics",
              child: ListTile(
                leading: const Icon(
                  Icons.trending_up_outlined,
                  color: Color.fromRGBO(3, 201, 169, 0.7),
                ),
                title: Text(
                  "Productivity",
                  style: GoogleFonts.aBeeZee(
                    textStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(3, 201, 169, 0.7), 
                    ),
                  ),
                ),
              ),
            ),
            PopupMenuItem(
              value: "Reminder",
              child: ListTile(
                leading: const Icon(Icons.calendar_month_outlined, color: Color.fromRGBO(236, 183, 102, 0.9)),
                title: Text(
                  "Schedule Reminder",
                  style: GoogleFonts.aBeeZee(
                    textStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(236, 183, 102, 0.9), 
                    ),
                  ),
                ),
              ),
            ),
            PopupMenuItem(
              value: "Settings",
              child: ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.orange),
                title: Text(
                  "Settings",
                  style: GoogleFonts.aBeeZee(
                    textStyle: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // Default color
                    ),
                  ),
                ),
              ),
            ),
          ],
          onSelected: (dynamic value) async {
            setState(() {});
            if (value == "Open"){
             Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DrawingPad(sketchbookID: widget.sketchbookID, sketchbookTitle: widget.title,)));
            } else if (value == "Settings") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SketchbookSettings(sketchbookTitle: widget.title, sketchbookDescription: widget.description, sketchbookID: widget.sketchbookID,)));
            } else if (value == "Reminder"){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScheduleReminder()));
            } else if (value == "Analytics") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatisticsScreen(sketchbookID: widget.sketchbookID,)));
            }
          },
        ),
      ),
    );
  }
}
