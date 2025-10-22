import 'package:flutter/material.dart';

// import 'package.flutter/material.dart';

class StudentLoginpage extends StatefulWidget {
  const StudentLoginpage({super.key});

  @override
  State<StudentLoginpage> createState() => _StudentLoginpageState();
}

class _StudentLoginpageState extends State<StudentLoginpage> {
  final _enrollmentController = TextEditingController();

  @override
  void dispose() {
    _enrollmentController.dispose();
    super.dispose();
  }

  // Helper for consistent text field styling, matching your theme
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: const TextStyle(
        fontFamily: "AirbnbCereal",
        color: Colors.black54,
      ),
      filled: true,
      fillColor: Colors.white,
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
          "Student/Faculty Login",
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
      // The body is now just the scrollable content
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // This ensures content aligns to the top
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Title ---
              const Text(
                "Welcome!",
                style: TextStyle(
                  fontFamily: "AirbnbCereal",
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                "Enter your enrollment number to continue.",
                style: TextStyle(
                  fontFamily: "AirbnbCereal",
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40.0),

              // --- Enrollment Number Field ---
              const Text(
                "Enrollment Number",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _enrollmentController,
                decoration: _buildInputDecoration("E.g., 12345678"),
                keyboardType: TextInputType.number,
              ),
              // The button has been removed from here
            ],
          ),
        ),
      ),
      // The button is now placed in the bottomNavigationBar
      bottomNavigationBar: SafeArea(
        // SafeArea avoids OS intrusions (like the home bar)
        child: Container(
          color:
              const Color.fromRGBO(255, 251, 230, 1.0), // Match the scaffold BG
          padding: const EdgeInsets.fromLTRB(
              24.0, 12.0, 24.0, 24.0), // Added padding
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Add login logic here
                final enrollmentNumber = _enrollmentController.text;
                debugPrint("Enrollment Number: $enrollmentNumber");
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
                "Submit",
                style: TextStyle(
                  fontFamily: "AirbnbCereal",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
