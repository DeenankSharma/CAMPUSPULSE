import 'package:dio/dio.dart'; // Import the dio package
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- Mock API Service (Removed) ---
// We are now using Dio for real network requests.

// --- Your Provider Class ---
class LoginDetailsProvider extends ChangeNotifier {
  // Private backing fields for your properties.
  String base_url = dotenv.env['BASE_URL'].toString();

  int _enr = 0;
  String _name = "";
  String _dept = "";
  String _hostel = "";
  String _gender = "";
  int _year = 0;
  int _semester = 0;
  bool _isstudent = true;

  // Create a Dio instance
  final Dio _dio = Dio();

  // --- 1. Getter Functions ---
  // These are the public "getters" you asked for.
  // Widgets can use these to read the current state.
  int get enr => _enr;
  String get name => _name;
  String get dept => _dept;
  String get hostel => _hostel;
  String get gender => _gender;
  int get year => _year;
  int get semester => _semester;
  bool get isstudent => _isstudent;

  // --- 2. Function to Fetch and Set Details (Updated with Dio) ---
  /// Fetches student details based on the enrollment number
  /// and updates the provider's state.
  ///
  /// After the data is set, it calls notifyListeners()
  /// to rebuild any widgets that are watching this provider.
  Future<void> fetchAndSetStudentDetails(String enrNumber) async {
    print("request recieved in provider");
    // --- IMPORTANT ---
    // Replace this with your actual API endpoint
    final String apiUrl = '$base_url/stufac/$enrNumber';

    try {
      // 1. Call the API service using Dio
      final response = await _dio.get(apiUrl);

      // Check for a successful response (e.g., status code 200)
      if (response.statusCode == 200) {
        // print("got response");
        // print(response.data['data']);
        // Dio automatically decodes JSON, so response.data is a Map
        final data = response.data['data'] as Map<String, dynamic>;
        // print(data);
        // 2. Set the details in this provider
        _enr = data['enr'];
        _name = data['name']?.trim();
        _dept = data['dept']?.trim();
        _hostel = data['hostel']?.trim();
        _gender = data['gender']?.trim();
        _year = data['year'];
        _semester = data['semester'];
        _isstudent = data['is_student'];

        // 3. Notify all listening widgets
        notifyListeners();
      } else {
        // Handle non-200 status codes (e.g., 404, 500)
        debugPrint("Error: Received status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      // This catches Dio-specific errors (network issues, timeouts, 404s, etc.)
      debugPrint("Dio error fetching student details: $e");
      // Optionally set an error state here
      _enr = 0;
      _name = "Error";
      _dept = "Error";
      _hostel = "Error";
      _gender = "Error";
      _year = 0;
      _semester = 0;
      _isstudent = true;
      notifyListeners();
    } catch (error) {
      // Catch any other unexpected errors
      debugPrint("Generic error fetching student details: $error");
    }
  }
}
