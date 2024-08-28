import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:canvas_vault/components/CustomTextField.dart';
import 'package:canvas_vault/components/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleReminder extends StatefulWidget {
  const ScheduleReminder({super.key});

  @override
  State<ScheduleReminder> createState() => _ScheduleReminderState();
}

class _ScheduleReminderState extends State<ScheduleReminder> {
  final TextEditingController _reminderTitle = TextEditingController();
  final TextEditingController _reminderDescription = TextEditingController();
  final TextEditingController _reminderDate = TextEditingController();
  final TextEditingController _reminderDateEnd = TextEditingController();
  String errorString = "";

  @override
  void dispose() {
    _reminderDate.dispose(); 
    _reminderTitle.dispose();
    _reminderDescription.dispose(); 
    _reminderDateEnd.dispose(); 
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(now).replaceAll('-', "/");
    _reminderDate.text = formattedDate;

    String formattedTime = DateFormat('hh:mm a').format(now);

    String finalDateTime = "$formattedDate, $formattedTime";
    _reminderDate.text = finalDateTime;

    DateTime oneHourLater = now.add(const Duration(hours: 1));
    String formattedDateEnd =
        DateFormat('yyyy-MM-dd').format(oneHourLater).replaceAll('-', "/");
    _reminderDateEnd.text = formattedDateEnd;
    String formattedTimeEnd = DateFormat('hh:mm a').format(oneHourLater);

    String finalDateTimeEnd = "$formattedDateEnd, $formattedTimeEnd";
    _reminderDateEnd.text = finalDateTimeEnd;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
        "Set a reminder to create your art",
        style: GoogleFonts.aBeeZee(fontSize: 18.5),
      )),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reminder Name", style: TextStyle(fontSize: 19)),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: _reminderTitle,
                  name: "Art Reminder",
                  inputType: TextInputType.text,
                  maxLen: 32,
                  numLines: 1,
                ),
                const SizedBox(height: 20),
                const Text("Reminder Description", style: TextStyle(fontSize: 19)),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: _reminderDescription,
                  name: "Don't forget to create your art!",
                  inputType: TextInputType.text,
                  maxLen: 80,
                  numLines: 3,
                ),
                const SizedBox(height: 20),
                const Text("Start Date", style: TextStyle(fontSize: 19)),
                const SizedBox(height: 10.0),
                CustomTextFieldDate(
                  isStart: true,
                  controller: _reminderDate,
                  leadingIcon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.orangeAccent,
                    size: 25,
                  ),
                  onlyRead: true,
                  name: "",
                  inputType: TextInputType.text,
                  maxLen: 80,
                  numLines: 1,
                ),
                const SizedBox(height: 20),
                const Text("End Date", style: TextStyle(fontSize: 19)),
                const SizedBox(height: 10.0),
                CustomTextFieldDate(
                  isStart: false,
                  controller: _reminderDateEnd,
                  leadingIcon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.orangeAccent,
                    size: 25,
                  ),
                  onlyRead: true,
                  name: "",
                  inputType: TextInputType.text,
                  maxLen: 80,
                  numLines: 1,
                ),
                const SizedBox(height: 45),
                errorString == ""
                            ? Container()
                            : Center(
                              child: Text(
                                  errorString,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                            ),
                const SizedBox(height: 15),
                SafeArea(
                  child: Center(
                    child: Container(
                      width: screenWidth,
                      child: GradientButtonFb1(
                        text: "Schedule Reminder",
                        onPressed: () async {
                          if (_reminderDate.text != "" &&
                              _reminderDescription.text != "" &&
                              _reminderTitle.text != "" &&
                              _reminderDate.text != "") {
                            List<String> parts = _reminderDate.text.split(', ');
                            String datePart = parts[0]; 
                            String timePart = parts[1]; 

                            DateFormat dateFormat = DateFormat('yyyy/MM/dd');
                            DateTime parsedDate = dateFormat.parse(datePart);

                            DateFormat timeFormat = DateFormat('hh:mm a');
                            DateTime parsedTime = timeFormat.parse(timePart);

                            DateTime combinedDateTimeStart = DateTime(
                              parsedDate.year,
                              parsedDate.month,
                              parsedDate.day,
                              parsedTime.hour,
                              parsedTime.minute,
                            );

                            List<String> partsEnd =
                                _reminderDateEnd.text.split(', ');
                            String datePartEnd = partsEnd[0]; 
                            String timePartEnd = partsEnd[1]; 

                            DateTime parsedDateEnd =
                                dateFormat.parse(datePartEnd);

                            DateTime parsedTimeEnd =
                                timeFormat.parse(timePartEnd);

                            DateTime combinedDateTimeStartEnd = DateTime(
                              parsedDateEnd.year,
                              parsedDateEnd.month,
                              parsedDateEnd.day,
                              parsedTimeEnd.hour,
                              parsedTimeEnd.minute,
                            );
                            if (combinedDateTimeStartEnd
                                .isAfter(combinedDateTimeStart)) {
                              final Event event = Event(
                                title: _reminderTitle.text,
                                description: _reminderDescription.text,
                                startDate: combinedDateTimeStart,
                                endDate: combinedDateTimeStartEnd,
                              );

                              await Add2Calendar.addEvent2Cal(event);
                              Navigator.of(context).pop(); 
                            } else {
                              setState(() {
                                errorString = "Starting date cannot be later than the ending date!";
                              });
                            }
                          } else {
                            setState(() {
                              errorString =
                                  "Title and description fields cannot be empty!";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
