import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.74.220:5454'; // Backend URL
  // static const String baseUrl = 'http://192.168.137.18:5454'; // Backend URL

  // Signup method
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String mobile,
    required String city,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'mobile': mobile,
          'city': city,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'User registered successfully',
        };
      } else {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'error',
          'message': responseData['message'] ?? 'Failed to register user',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }

  // Login method
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'success',
          'token': responseData['token'], // Assuming backend sends a token
        };
      } else {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'error',
          'message': responseData['message'] ?? 'Failed to log in',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }

  // Add to Wishlist method
  static Future<Map<String, dynamic>> addToWishlist({
    required int userId,
    required String bookName,
    required String bookWriter,
    String? description,
    String? imagePath,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'book_name': bookName,
          'book_writer': bookWriter,
          'description': description ?? '', // Optional description
          'image_path': imagePath ?? '', // Optional image path
        }),
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Book added to wishlist successfully',
        };
      } else {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'error',
          'message':
              responseData['message'] ?? 'Failed to add book to wishlist',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }

  // Get Wishlist method (returns a list of books)
  static Future<List<Map<String, dynamic>>> getWishlist(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch wishlist');
      }
    } catch (error) {
      print('Get Wishlist Error: $error');
      return []; // Return an empty list in case of error
    }
  }

  // Remove from Wishlist method
  static Future<Map<String, dynamic>> removeFromWishlist(int wishlistId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/$wishlistId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Book removed from wishlist successfully',
        };
      } else {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'error',
          'message':
              responseData['message'] ?? 'Failed to remove book from wishlist',
        };
      }
    } catch (error) {
      print('Remove from Wishlist Error: $error');
      return {'status': 'error', 'message': error.toString()};
    }
  }

  // Forgot Password method
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgotpassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'success',
          'message': responseData['message'] ??
              'Verification code sent to your email.',
        };
      } else {
        final responseData = jsonDecode(response.body.toString());
        return {
          'status': 'error',
          'message':
              responseData['message'] ?? 'Failed to send verification code.',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }

  // Update Profile method
  static Future<Map<String, dynamic>> updateProfile({
    required String username,
    required String city,
    File? profileImage,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/updateprofile');
      var request = http.MultipartRequest('PUT', uri);

      // Add text fields
      request.fields['username'] = username;
      request.fields['city'] = city;

      // Add image if provided
      if (profileImage != null) {
        var imageStream = http.ByteStream(profileImage.openRead());
        var imageLength = await profileImage.length();
        var multipartFile = http.MultipartFile(
          'profile_image',
          imageStream,
          imageLength,
          filename: basename(profileImage.path),
        );
        request.files.add(multipartFile);
      }

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Profile updated successfully',
        };
      } else {
        return {
          'status': 'error',
          'message':
              jsonDecode(responseData)['message'] ?? 'Failed to update profile',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred: ${error.toString()}',
      };
    }
  }
}
