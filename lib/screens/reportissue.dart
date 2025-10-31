import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// --- MODIFIED IMPORTS ---
import '../providers/issue_provider.dart';
// !! ADJUST PATH AS NEEDED !!
import '../providers/student_details_provider.dart'; // <-- NEW IMPORT
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
  // final _enrController = TextEditingController(); // <-- REMOVED

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  Position? _currentPosition;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // _enrController.dispose(); // <-- REMOVED
    super.dispose();
  }

  // --- (Helper functions _pickImage and _getCurrentLocation are unchanged) ---
  Future<void> _pickImage() async {
    // ... (your existing _pickImage code)
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    // ... (your existing _getCurrentLocation code)
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')));
      }
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Location permissions are denied.')));
        }
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        print(position);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location added successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }
  // --- (End of unchanged helper functions) ---

  // --- MODIFIED SUBMIT FUNCTION ---
  Future<void> _submitIssue() async {
    // 1. Get Providers
    final issueProvider = context.read<IssuesProvider>();
    // --- NEW: Get LoginDetailsProvider ---
    final loginProvider = context.read<LoginDetailsProvider>();

    // 2. Validation
    // --- MODIFIED: Get ENR from provider ---
    // (This assumes your LoginDetailsProvider has a getter `enrNumber`)
    final int userEnr = loginProvider.enr;

    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill in a title and description.')));
      return;
    }

    // --- VALIDATION (Updated) ---
    if (userEnr == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not find user ID. Please log in again.')));
      return;
    }
    // --- END VALIDATION ---

    if (_selectedDomain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an issue domain.')));
      return;
    }

    // 3. Call the createIssue function
    try {
      final bool success = await issueProvider.createIssue(
        title: _titleController.text,
        description: _descriptionController.text,
        domain: _selectedDomain!,
        criticalLevel: _criticalLevel.round(),
        reportedByEnr: userEnr, // <-- Pass the ENR from the provider
        image: _pickedImage,
        location: _currentPosition,
      );

      // 4. Handle the result
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Issue reported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(issueProvider.error ??
                  'Failed to create issue. Unknown error.'),
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
    }
  }
  // --- END MODIFIED SUBMIT FUNCTION ---

  InputDecoration _buildInputDecoration(String label) {
    // ... (your existing _buildInputDecoration code is unchanged)
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

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<IssuesProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        // ... (app bar code is unchanged)
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
        iconTheme: const IconThemeData(color: Colors.black),
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
                enabled: !isLoading,
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
                enabled: !isLoading,
              ),
              const SizedBox(height: 20.0),

              // --- REMOVED ENROLLMENT NUMBER FIELD ---

              // --- Add Image Tile ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : _pickImage,
                  icon: Icon(
                    _pickedImage == null
                        ? Icons.add_a_photo_outlined
                        : Icons.check_circle_outline,
                    color: const Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  label: Text(
                    _pickedImage == null
                        ? "Add Image"
                        : "Change Image (${_pickedImage!.name.length > 20 ? '${_pickedImage!.name.substring(0, 20)}...' : _pickedImage!.name})",
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
              const SizedBox(height: 12.0),

              // --- Add Location Tile ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : _getCurrentLocation,
                  icon: Icon(
                    _currentPosition == null
                        ? Icons.add_location_alt_outlined
                        : Icons.check_circle_outline,
                    color: const Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                  label: Text(
                    _currentPosition == null
                        ? "Add Location"
                        : "Location Added",
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

              // ... (Rest of the form is unchanged)
              Visibility(
                visible: _currentPosition != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Lat: ${_currentPosition?.latitude.toStringAsFixed(4)}, Lon: ${_currentPosition?.longitude.toStringAsFixed(4)}",
                    style: const TextStyle(
                      fontFamily: "AirbnbCereal",
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Issue Domain",
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
                onChanged: isLoading
                    ? null
                    : (newValue) {
                        setState(() {
                          _selectedDomain = newValue;
                        });
                      },
              ),
              const SizedBox(height: 20.0),
              Text(
                "Critical Level: ${_criticalLevel.round()}",
                style: const TextStyle(
                    fontFamily: "AirbnbCarial",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
              Slider(
                value: _criticalLevel,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: _criticalLevel.round().toString(),
                activeColor: const Color.fromRGBO(255, 90, 96, 1.0),
                inactiveColor: const Color.fromRGBO(255, 90, 96, 0.3),
                onChanged: isLoading
                    ? null
                    : (newValue) {
                        setState(() {
                          _criticalLevel = newValue;
                        });
                      },
              ),
              const SizedBox(height: 20.0),

              // --- Submit Button (Unchanged, but logic now works) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitIssue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading
                        ? Colors.grey
                        : const Color.fromRGBO(255, 90, 96, 1.0),
                    foregroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
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
