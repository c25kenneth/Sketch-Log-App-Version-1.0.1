import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final int numLines;
  final int maxLen;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.name,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    required this.numLines,
    required this.maxLen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: maxLen,
        maxLines: numLines,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          isDense: true,
          labelText: name,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldDate extends StatelessWidget {
  final bool isStart; 
  final TextEditingController controller;
  final String name;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final int numLines;
  final int maxLen;
  final bool onlyRead;
  final Icon leadingIcon;

  const CustomTextFieldDate({
    Key? key,
    required this.isStart,
    required this.controller,
    required this.name,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    required this.numLines,
    required this.maxLen,
    required this.onlyRead,
    required this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        onTap: () async {
          DateTime? dateTime = await showOmniDateTimePicker(
            context: context,
            theme: ThemeData.light().copyWith(
              primaryColor: const Color.fromRGBO(253,183,119, 1), 
              hintColor: const Color.fromRGBO(253,183,119, 1), 
              colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(253,183,119, 1), 
                onPrimary: Colors.black,
                onSurface: Colors.black,
                surfaceTint: Colors.transparent 
              ),
              dialogBackgroundColor: Colors.white,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange, 
                ),
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.orange, 
              ),
              cardColor: Colors.white,
            ),
          );

          if (dateTime != null) {  
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime).replaceAll('-', "/");
            String formattedTime = DateFormat('hh:mm a').format(dateTime); 
            String finalDateTime = "$formattedDate, $formattedTime"; 
            
            controller.text = finalDateTime; 
          }
        },
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: maxLen,
        maxLines: numLines,
        obscureText: obscureText,
        keyboardType: inputType,
        readOnly: onlyRead,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          isDense: true,
          labelText: name,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
