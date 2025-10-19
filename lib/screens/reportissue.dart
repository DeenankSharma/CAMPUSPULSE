import 'package:flutter/material.dart';

import '../utils/issuecategories.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  // State variables to hold form data
  double _criticalLevel = 1.0;
  String? _selectedDomain;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // A helper to build consistent text field decorations
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: const TextStyle(
        fontFamily: "AirbnbCereal",
        color: Colors.black54,
      ),
      filled: true,
      fillColor: Color.fromRGBO(
          255, 251, 230, 1.0), // A white bg makes form fields stand out
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: Color.fromRGBO(255, 90, 96, 1.0), // Theme color on focus
          width: 2.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0), // Theme bg
      appBar: AppBar(
        title: const Text(
          "Report an Issue",
          style: TextStyle(
            fontFamily: "AirbnbCereal",
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.black), // Back button color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Title ---
              const Text(
                "Issue Title",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _titleController,
                decoration: _buildInputDecoration(""),
              ),
              const SizedBox(height: 20.0),

              // --- Description ---
              const Text(
                "Description",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _descriptionController,
                decoration:
                    _buildInputDecoration("Describe the issue in detail..."),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20.0),

              // --- Add Image Tile ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Add image picker logic
                  },
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    color: Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  label: const Text("Add Image"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 90, 96, 1.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),

              // --- Add Location Tile ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Add location picker logic
                  },
                  icon: const Icon(
                    Icons.add_location_alt_outlined,
                    color: Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  label: const Text("Add Location"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 90, 96, 1.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // --- Domain Selection ---
              const Text(
                "Issue Domain",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),

              // We remove the Theme widget and add properties directly here
              DropdownButtonFormField<String>(
                value: _selectedDomain,
                hint: const Text("Select a domain"),
                decoration:
                    _buildInputDecoration(""), // Your decoration is correct

                // --- ADD THESE ---
                dropdownColor: const Color.fromRGBO(255, 251, 230, 1.0),
                borderRadius: BorderRadius.circular(12.0),
                isExpanded: true,
                // --- END OF ADDITIONS ---

                items: issueCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['text'] as String,
                    child: Row(
                      children: [
                        Icon(category['icon'] as IconData,
                            color: Colors.grey.shade700, size: 20),
                        const SizedBox(width: 10),
                        Text(category['text'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDomain = newValue;
                  });
                },
              ),
              const SizedBox(height: 20.0),

              // ... (rest of your code)

              // --- Critical Level Scale ---
              Text(
                "Critical Level: ${_criticalLevel.round()}",
                style: const TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _criticalLevel,
                min: 1.0,
                max: 5.0,
                divisions: 4, // 4 divisions create 5 stops (1, 2, 3, 4, 5)
                label: _criticalLevel.round().toString(),
                activeColor: const Color.fromRGBO(255, 90, 96, 1.0),
                inactiveColor: const Color.fromRGBO(255, 90, 96, 0.3),
                onChanged: (newValue) {
                  setState(() {
                    _criticalLevel = newValue;
                  });
                },
              ),
              const SizedBox(height: 20.0),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add submit logic
                    // You can access all data:
                    // _titleController.text
                    // _descriptionController.text
                    // _selectedDomain
                    // _criticalLevel.round()
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
                    foregroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Submit Report",
                    style: TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
