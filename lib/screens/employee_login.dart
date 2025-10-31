import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/employee_details_provider.dart';
// import 'package:provider/provider.dart';
// import '../providers/employee_auth_provider.dart'; // You would import your employee provider here

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  State<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  final _employeeIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final employeeId = _employeeIdController.text.trim().toString();

    // Basic validation
    if (employeeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an employee ID.")),
      );
      return;
    }

    // 1. Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Call your provider's function
      // In a real app, this is where you'd call your auth provider
      final authProvider = context.read<EmployeeAuthProvider>();
      final bool loginSuccess =
          await authProvider.fetchAndSetEmployeeDetails(employeeId);

      // 3. Check for success
      if (loginSuccess) {
        // Success! Navigate to the employee home page.
        if (mounted) {
          // Use pushReplacement so the user can't go "back" to the login screen
          context.go('/emphome');
        }
      } else {
        // Handle login failure
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Login Failed. Please check your employee ID.")),
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
          "Employee Login",
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
      // The body is for scrollable content
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
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
                "Enter your employee ID to continue.",
                style: TextStyle(
                  fontFamily: "AirbnbCereal",
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40.0),

              // --- Employee ID Field ---
              const Text(
                "Employee ID",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _employeeIdController,
                decoration: _buildInputDecoration("E.g., 12345678"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),

              // --- Sign Up Option ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not registered? ",
                    style: TextStyle(
                      fontFamily: "AirbnbCereal",
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            context.pushReplacement('/empsignup');
                          },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Sign up here",
                      style: TextStyle(
                        fontFamily: "AirbnbCereal",
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(255, 90, 96, 1.0),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // The button is placed in the bottomNavigationBar
      bottomNavigationBar: SafeArea(
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
