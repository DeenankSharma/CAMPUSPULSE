import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/student_details_provider.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginpageState();
}

class _StudentLoginpageState extends State<StudentLoginScreen> {
  final _enrollmentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _enrollmentController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final enrollmentNumber = _enrollmentController.text.trim();

    // Basic validation
    if (enrollmentNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an enrollment number.")),
      );
      return;
    }

    // 1. Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      print("sending request from screen");
      // 2. Call the provider's function
      // We use context.read() here because we are in a function
      // and not in the build method.
      final loginProvider = context.read<LoginDetailsProvider>();
      await loginProvider.fetchAndSetStudentDetails(enrollmentNumber);

      // 3. Check for success *after* the await
      // Your provider sets 'name' to "Error" on failure.
      if (loginProvider.name != "Error") {
        // Success! Navigate to the home page.
        // We check 'mounted' because this is an async operation.
        if (mounted) {
          // Use pushReplacement so the user can't go "back" to the login screen
          context.go('/studenthome');
        }
      } else {
        // Handle the error (e.g., student not found)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Login Failed. Please check your enrollment number.")),
          );
        }
      }
    } catch (e) {
      // Handle any other unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } finally {
      // 4. Stop loading, no matter what
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              onPressed: _isLoading ? null : _submitLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 90, 96, 1.0),
                foregroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(255, 251, 230, 1.0),
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
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
