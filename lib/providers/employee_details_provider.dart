import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import '../services/imgbb_services.dart';

class EmployeeAuthProvider extends ChangeNotifier {
  // --- Private Backing Fields ---
  String base_url = dotenv.env['BASE_URL'].toString();
  int _empId = 0;
  String _name = "";
  String _role = "";
  String _dept = "";
  String _domain = "";
  String _proofUrl = "";

  bool _isLoading = false;
  String? _error;

  // Dio instance
  final Dio _dio = Dio();

  // --- 1. Getter Functions ---
  int get empId => _empId;
  String get name => _name;
  String get role => _role;
  String get dept => _dept;
  String get domain => _domain;
  String get proofUrl => _proofUrl;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Helper Methods for State ---
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
  }

  void _clearData() {
    _empId = 0;
    _name = "";
    _role = "";
    _dept = "";
    _domain = "";
    _proofUrl = "";
    _error = null;
  }

  // --- 2. Function to Fetch (Login) ---
  /// Fetches employee details based on the employee ID
  /// and updates the provider's state.
  Future<bool> fetchAndSetEmployeeDetails(String empId) async {
    _setLoading(true);
    _setError(null);
    _clearData(); // Clear previous user data

    final String apiUrl = '$base_url/employee/$empId';

    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        _empId = data['emp_id'];
        _name = data['name']?.trim();
        _role = data['role']?.trim();
        _dept = data['dept']?.trim();
        _domain = data['domain']?.trim();
        _proofUrl = data['proof']?.trim();
        return true;
      } else {
        debugPrint("Error: Received status code ${response.statusCode}");
        _setError("Login failed: Server error");
        _name = "Error"; // Set error flag for the UI to check
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio error fetching employee details: $e");
      _setError(e.message ?? "A network error occurred");
      _name = "Error"; // Set error flag
      return false;
    } catch (error) {
      debugPrint("Generic error fetching employee details: $error");
      _setError("An unexpected error occurred");
      _name = "Error"; // Set error flag
      return false;
    } finally {
      _setLoading(false);
      // Notify listeners *after* all changes are made
      notifyListeners();
    }
  }

  // --- 3. Function to Sign Up ---
  /// Registers a new employee, starting with uploading the proof image.
  /// Returns `true` on success and `false` on failure.
  Future<bool> signUp({
    required String empId,
    required String name,
    required String role,
    required String dept,
    required String domain,
    required XFile proofImage,
  }) async {
    _setLoading(true);
    _setError(null);

    String? publicImageUrl;

    // --- Step 1: Upload Image (as per your example) ---
    try {
      File imagetoupload = File(proofImage.path);
      String API_KEY = dotenv.env['IMGBB_API_KEY'].toString() ?? "fallback_key";

      // !! IMPORTANT: You must have this function defined elsewhere !!
      publicImageUrl = await uploadImage(API_KEY, imagetoupload);

      if (publicImageUrl == null) {
        debugPrint("Image upload failed, stopping signup.");
        _setError("Failed to upload proof image. Please try again.");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint("Image upload failed: $e");
      _setError("Failed to upload proof image. Please try again.");
      _setLoading(false);
      return false; // Stop the function if image upload fails
    }

    // --- Step 2: Send Sign-Up Data to your API ---
    final String apiUrl = '$base_url/employee/signup';
    final Map<String, dynamic> payload = {
      'emp_id': int.tryParse(empId) ?? 0,
      'name': name,
      'role': role,
      'dept': dept,
      'domain': domain,
      'proof': publicImageUrl,
    };

    try {
      final response = await _dio.post(apiUrl, data: payload);

      // 201 Created is the typical success code for a new resource
      if (response.statusCode == 201) {
        debugPrint("Signup successful");
        _setLoading(false);
        return true;
      } else {
        debugPrint("Error: Signup failed with code ${response.statusCode}");
        _setError(response.data['message'] ?? "Sign up failed");
        _setLoading(false);
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio error during signup: $e");
      _setError(e.response?.data['message'] ??
          e.message ??
          "A network error occurred");
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint("Generic error during signup: $e");
      _setError("An unexpected error occurred");
      _setLoading(false);
      return false;
    }
  }
}
