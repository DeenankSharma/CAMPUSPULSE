import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

/// Uploads an image to the imgbb API using Dio.
///
/// Returns the public URL as a String if successful.
/// Returns null if the upload fails for any reason.
Future<String?> uploadImage(String apiKey, File imageFile) async {
  var dio = Dio();
  var url = 'https://api.imgbb.com/1/upload';

  try {
    String fileName = path.basename(imageFile.path);

    FormData formData = FormData.fromMap({
      'key': apiKey,
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    Response response = await dio.post(
      url,
      data: formData,
    );

    if (response.statusCode == 200) {
      // Parse the URL from the successful response
      // The exact path depends on the API's response structure
      final imageUrl = response.data['data']['url'];
      print('Upload successful! URL: $imageUrl');
      return imageUrl; // <-- CHANGED: Return the URL
    } else {
      print('Upload failed with status code: ${response.statusCode}');
      print('Response: ${response.data}');
      return null; // <-- CHANGED: Return null on failure
    }
  } on DioException catch (e) {
    print('Error uploading image: $e');
    if (e.response != null) {
      print('Error response: ${e.response?.data}');
    }
    return null; // <-- CHANGED: Return null on error
  } catch (e) {
    print('An unexpected error occurred: $e');
    return null; // <-- CHANGED: Return null on error
  }
}
