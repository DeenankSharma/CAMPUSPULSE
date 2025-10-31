import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/employee_details_provider.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Watch the EmployeeAuthProvider
    final employeeDetails = context.watch<EmployeeAuthProvider>();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 251, 230, 1.0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: "AirbnbCereal",
            fontWeight: FontWeight.w900,
            color: Colors.black,
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
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(255, 90, 96, 0.1),
                  child: Icon(
                    Icons.engineering, // Changed icon for 'employee'
                    size: 60,
                    color: Color.fromRGBO(255, 90, 96, 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  employeeDetails.name, // From employee provider
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
                  employeeDetails.role, // Use 'role' from provider
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

              // --- Profile Details (mapped to employee data) ---
              _buildInfoRow("Employee ID", employeeDetails.empId.toString()),
              _buildInfoRow("Department", employeeDetails.dept),
              _buildInfoRow("Domain", employeeDetails.domain),
              // You could also add:
              // _buildInfoRow("Proof", employeeDetails.proofUrl),
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
