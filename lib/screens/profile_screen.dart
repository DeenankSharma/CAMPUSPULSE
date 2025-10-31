import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_details_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Watch the provider to get user details
    // This will rebuild the widget if details change.
    final userDetails = context.watch<LoginDetailsProvider>();

    return Scaffold(
      // Use the same background color from your inspiration
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        // Match the style
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        elevation: 0, // No shadow for a cleaner look
        // This will automatically add a back button if you pushed this screen
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: "AirbnbCereal",
            fontWeight: FontWeight.w900,
            color: Colors.black, // Ensure title is visible
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Profile Header ---
              Center(
                child: CircleAvatar(
                  radius: 50,
                  // Use your app's accent color for the avatar
                  backgroundColor: const Color.fromRGBO(255, 90, 96, 0.1),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  userDetails.name,
                  style: const TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontWeight: FontWeight.w900,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  // Assuming 'istudnet' was a typo for 'isStudent'
                  userDetails.isstudent ? "Student" : "Staff",
                  style: const TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.black12, thickness: 1),
              const SizedBox(height: 16),

              // --- Profile Details ---
              _buildInfoRow("Department", userDetails.dept),
              _buildInfoRow("Hostel", userDetails.hostel),
              _buildInfoRow("Year", userDetails.year.toString()),
              _buildInfoRow("Semester", userDetails.semester.toString()),
              _buildInfoRow("Gender", userDetails.gender),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper widget to build consistently styled info rows.
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 100, // Gives labels a fixed width for alignment
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: "AirbnbCereal",
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Value
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: "AirbnbCereal",
                fontWeight: FontWeight.w700, // Bolder value
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
