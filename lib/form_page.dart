import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController taskController = TextEditingController();
  final List<Map<String, dynamic>> tasks = [];
  DateTime? selectedDate;
  bool isDateValid = true;
  final Color customColor = Colors.deepPurple[400]!;

  void showDateTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set Task Date & Time",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 25),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: selectedDate ?? DateTime.now(),
                use24hFormat: false,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedDate = newDateTime;
                  isDateValid = true;
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 160),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDate ??= DateTime.now();
                      isDateValid = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Select",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTask() {
    setState(() {
      isDateValid = selectedDate != null;
    });
    if (formKey.currentState!.validate() && isDateValid) {
      setState(() {
        tasks.add({
          "title": taskController.text,
          "deadline": selectedDate!,
          "done": false,
        });
        taskController.clear();
        selectedDate = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Task added successfully"),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Task Date:", style: TextStyle(fontSize: 16, color: Colors.black),), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('dd-MM-yyyy HH:mm').format(selectedDate!)
                              : "Select a date", style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        if (!isDateValid)
                          const Text(
                            "Please select a date",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: showDateTimePicker,
                      icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: taskController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "Enter your First Name",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: customColor, width: 2),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Please enter some text" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: addTask,
                      style: FilledButton.styleFrom(backgroundColor: customColor),
                      child: const Text("Submit"),
                    ),
                  ],
                ),
