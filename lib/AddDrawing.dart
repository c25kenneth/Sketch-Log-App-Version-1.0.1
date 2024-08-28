import 'package:canvas_vault/components/CustomTextField.dart';
import 'package:flutter/material.dart';

class AddDrawing extends StatefulWidget {
  final String sketchbookID;
  const AddDrawing({super.key, required this.sketchbookID});

  @override
  State<AddDrawing> createState() => _AddDrawingState();
}

class _AddDrawingState extends State<AddDrawing> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String errorString = ""; 
  
  @override
  void dispose() {
    _nameController.dispose(); 
    _descriptionController.dispose(); 
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add an Idea"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Artwork Name", style: TextStyle(fontSize: 19)),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: _nameController,
              name: "Awesome Art Idea",
              inputType: TextInputType.text,
              maxLen: 32,
              numLines: 1,
            ),
            const SizedBox(height: 15),
            const Text("Art Description", style: TextStyle(fontSize: 19)),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: _descriptionController,
              name: "Beautiful Flower Gardins",
              inputType: TextInputType.multiline,
              numLines: 4,
              maxLen: 120,
            ),
            const Spacer(),
            Center(
              child: Container(
              width: screenWidth * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.orange, width: 2), // Orange border
              ),
              child: ElevatedButton(
                onPressed: () async {
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), 
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text("Add Drawing", style: TextStyle(color: Colors.orange)),
                ),
              ),
                        ),
            ),
            
            const SizedBox(height: 15.0),
            Center(child: (errorString != "") ? Text(errorString, style: const TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,) : const SizedBox()),
            const SizedBox(height: 85),
          ],
        ),
      ),
    );
  }
}