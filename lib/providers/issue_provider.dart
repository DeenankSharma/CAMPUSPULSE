import 'dart:io';

import 'package:campus_pulse/services/imgbb_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart'; // For Position type
import 'package:image_picker/image_picker.dart'; // For XFile type

// --- 1. Issue Model Class ---
// It's best practice to have a model class for your data.
// This converts the JSON map from the API into a real Dart object.
class Issue {
  final int id;
  final String title;
  final String desc;
  final String domain;
  final int critical;
  // final String status;
  final int enr; // e.g., enrollment number
  final String? image_url; // Can be null
  final double? lat; // Can be null
  final double? long; // Can be null
  final bool? isresolved;
  // final DateTime createdAt;

  Issue(
      {required this.id,
      required this.title,
      required this.desc,
      required this.domain,
      required this.critical,
      // required this.status,
      required this.enr,
      this.image_url,
      this.lat,
      this.long,
      this.isresolved});

  // Factory constructor to create an Issue from JSON
  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        // Use '??' to provide default values if a field might be missing
        id: json['id'] ?? 0, // Assuming MongoDB-style ID
        title: json['title'] ?? 'No Title',
        desc: json['desc'] ?? '',
        domain: json['domain'] ?? 'Other',
        critical: json['critical'] ?? 1,
        // status: json['status'] ?? 'Pending',
        enr: json['enr'] ?? 0,
        image_url: json['image_url'], // This is fine if it's null
        lat: (json['lat'] as num?)?.toDouble(),
        long: (json['long'] as num?)?.toDouble(),
        isresolved: json['isresolved'] ?? false
        // createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        );
  }
}

// --- 2. Issues Provider Class ---
class IssuesProvider extends ChangeNotifier {
  // Create a Dio instance
  final Dio _dio = Dio();

  // --- IMPORTANT ---
  // Base URL for your API.
  final String _baseUrl = dotenv.env['BASE_URL'].toString();

  // --- State Variables ---
  List<Issue> _issues = [];
  bool _isLoading = false;
  String? _error;

  // --- Public Getters ---
  // Widgets can use these to read the current state.
  List<Issue> get issues => _issues;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Internal Helper Functions for State ---
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // --- 3. Function to Fetch All Issues ---
  /// Fetches all issues from the API and updates the list.
  Future<void> fetchAllIssues() async {
    _setLoading(true);
    _setError(null);

    // --- TODO: Confirm this API endpoint ---
    final String apiUrl = '$_baseUrl/issues';

    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        // Assuming your API returns a 'data' key with a list of issues
        final List<dynamic> data = response.data['data'];

        // Map the list of JSON objects to a list of our Issue objects
        _issues = data.map((json) => Issue.fromJson(json)).toList();
      } else {
        _setError("Error: Received status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error fetching issues: $e");
      _setError(e.message ?? 'An unknown Dio error occurred');
    } catch (e) {
      debugPrint("Generic error fetching issues: $e");
      _setError(e.toString());
    } finally {
      // Always stop loading, even if there was an error
      _setLoading(false);
    }
  }

  // --- 4. Function to Create a New Issue ---
  /// Submits a new issue to the API.
  /// This handles file uploads using FormData.
  /// Returns `true` on success and `false` on failure.
  Future<bool> createIssue({
    required String title,
    required String description,
    required String domain,
    required int criticalLevel,
    required int reportedByEnr,
    XFile? image, // The picked image file
    Position? location, // The picked location
  }) async {
    _setLoading(true);
    _setError(null);

    final String apiUrl = '$_baseUrl/issues';
    String? publicImageUrl;

    try {
      // 1. Handle the image file if it exists
      if (image != null) {
        // --- MODIFIED SECTION: Upload to Supabase first ---
        try {
          // final dio = Dio();
          File imagetoupload = File(image.path);
          String API_KEY =
              dotenv.env['IMGBB_API_KEY'].toString() ?? "fallback_key";
          publicImageUrl = await uploadImage(API_KEY, imagetoupload);
          if (publicImageUrl == null) {
            // <-- CHANGED: Clean error check
            debugPrint("Image upload failed, stopping issue creation.");
            _setError("Failed to upload image. Please try again.");
            _setLoading(false);
            return false;
          }
        } catch (e) {
          // Handle image upload error specifically
          debugPrint(" upload failed: $e");
          _setError("Failed to upload image. Please try again.");
          _setLoading(false);
          return false; // Stop the function if image upload fails
        }
        // --- END OF MODIFIED SECTION ---
      }

      // 2. Create the data map
      // We no longer send form-data, we send a JSON map.
      Map<String, dynamic> dataMap = {
        'title': title,
        'desc': description,
        'domain': domain,
        'critical': criticalLevel,
        'enr': reportedByEnr,
        'lat': location?.latitude,
        'long': location?.longitude,
        'image_url': publicImageUrl, // <-- MODIFIED: Send the URL string
      };

      // Optional: Remove null values if your backend prefers it
      dataMap.removeWhere((key, value) => value == null);

      // 3. Send the POST request as JSON
      // We pass `dataMap` directly. Dio will send it as 'application/json'.
      final response = await _dio.post(apiUrl, data: dataMap); // <-- MODIFIED

      // 4. Handle the response
      if (response.statusCode == 201) {
        final newIssue = Issue.fromJson(response.data['data']);
        _issues.insert(0, newIssue);
        _setLoading(false);
        return true;
      } else {
        _setError("Error: Received status code ${response.statusCode}");
        _setLoading(false);
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio error creating issue: $e");
      _setError(e.message ?? 'An unknown Dio error occurred');
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint("Generic error creating issue: $e");
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
