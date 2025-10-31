import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/employee_details_provider.dart';
import '../utils/departmentOptions.dart';
import '../utils/domainOptions.dart';

// import 'package:provider/provider.dart';
// import '../providers/employee_auth_provider.dart'; // <-- You'll need to create/import this

// --- NEW: Lists for Dropdowns ---
// You can edit these lists to match your database

// --- END NEW ---

class EmployeeSignUpScreen extends StatefulWidget {
  const EmployeeSignUpScreen({super.key});

  @override
  State<EmployeeSignUpScreen> createState() => _EmployeeSignUpScreenState();
}

class _EmployeeSignUpScreenState extends State<EmployeeSignUpScreen> {
  // State variables for form data
  final _empIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  // final _deptController = TextEditingController(); // <-- REPLACED
  // final _domainController = TextEditingController(); // <-- REPLACED

  // --- NEW: State for dropdowns ---
  String? _selectedDept;
  String? _selectedDomain;
  // --- END NEW ---

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedProofImage;

  bool _isLoading = false;

  @override
  void dispose() {
    _empIdController.dispose();
    _nameController.dispose();
    _roleController.dispose();
    // _deptController.dispose(); // <-- REMOVED
    // _domainController.dispose(); // <-- REMOVED
    super.dispose();
  }

  // Helper function to pick an image (unchanged)
  Future<void> _pickProofImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedProofImage = image;
      });
    }
  }

  // --- MODIFIED SUBMIT FUNCTION ---
  Future<void> _submitSignUp() async {
    // 1. Get Provider
    final authProvider = context.read<EmployeeAuthProvider>();

    // 2. Validation
    if (_empIdController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all text fields.')));
      return;
    }

    // --- NEW: Dropdown validation ---
    if (_selectedDept == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a department.')));
      return;
    }
    if (_selectedDomain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a domain.')));
      return;
    }
    // --- END NEW ---

    if (_pickedProofImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please upload a proof document/image.')));
      return;
    }

    // 3. Set loading and call provider
    setState(() {
      _isLoading = true;
    });

    try {
      // --- THIS IS WHERE YOU WOULD CALL YOUR PROVIDER ---
      final bool success = await authProvider.signUp(
        empId: _empIdController.text,
        name: _nameController.text,
        role: _roleController.text,
        dept: _selectedDept!, // <-- UPDATED
        domain: _selectedDomain!, // <-- UPDATED
        proofImage: XFile(_pickedProofImage!.path),
      );

      // 4. Handle the result
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successful! Please log in.'),
              backgroundColor: Colors.green,
            ),
          );
          // Go back to the login screen
          context.go('/emplogin');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sign up. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 5. Stop loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Input Decoration Helper (copied from your file) ---
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: const TextStyle(
        fontFamily: "AirbnbCereal",
        color: Colors.black54,
      ),
      filled: true,
      fillColor: const Color.fromRGBO(255, 251, 230, 1.0),
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
          color: Color.fromRGBO(255, 90, 96, 1.0),
          width: 2.0,
        ),
      ),
    );
  }
  // --- End of helper ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        title: const Text(
          "Employee Sign Up",
          style: TextStyle(
            fontFamily: "AirbnbCereal",
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Employee ID ---
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
                controller: _empIdController,
                decoration: _buildInputDecoration("E.g., 12345678"),
                keyboardType: TextInputType.number,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20.0),

              // --- Full Name ---
              const Text(
                "Full Name",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _nameController,
                decoration: _buildInputDecoration("E.g., Ram Kishan"),
                keyboardType: TextInputType.name,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20.0),

              // --- Role ---
              const Text(
                "Role",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                cursorColor: Colors.black,
                controller: _roleController,
                decoration: _buildInputDecoration("E.g., Worker"),
                keyboardType: TextInputType.text,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20.0),

              // --- MODIFIED: Department ---
              const Text(
                "Department",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedDept,
                hint: const Text("Select a department"),
                decoration: _buildInputDecoration(""),
                dropdownColor: const Color.fromRGBO(255, 251, 230, 1.0),
                borderRadius: BorderRadius.circular(12.0),
                isExpanded: true,
                items: departmentOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (newValue) {
                        setState(() {
                          _selectedDept = newValue;
                        });
                      },
              ),
              const SizedBox(height: 20.0),

              // --- MODIFIED: Domain ---
              const Text(
                "Domain",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedDomain,
                hint: const Text("Select a domain"),
                decoration: _buildInputDecoration(""),
                dropdownColor: const Color.fromRGBO(255, 251, 230, 1.0),
                borderRadius: BorderRadius.circular(12.0),
                isExpanded: true,
                items: domainOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (newValue) {
                        setState(() {
                          _selectedDomain = newValue;
                        });
                      },
              ),
              const SizedBox(height: 20.0),

              // --- Upload Proof Button (Unchanged) ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _pickProofImage,
                  icon: Icon(
                    _pickedProofImage == null
                        ? Icons.upload_file_outlined
                        : Icons.check_circle_outline,
                    color: const Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  label: Text(
                    _pickedProofImage == null
                        ? "Upload Proof"
                        : "Image Added (${_pickedProofImage!.name.length > 20 ? '${_pickedProofImage!.name.substring(0, 20)}...' : _pickedProofImage!.name})",
                  ),
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
              const SizedBox(height: 30.0), // Extra space before submit

              // --- Submit Button (Unchanged) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? Colors.grey
                        : const Color.fromRGBO(255, 90, 96, 1.0),
                    foregroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Sign Up",
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
