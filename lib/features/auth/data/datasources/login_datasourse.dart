import 'dart:convert';

import 'package:dev2dev/core/config/constants.dart';
import 'package:dio/dio.dart';

class LoginDatasourse {
  final Dio dio;
  LoginDatasourse({required this.dio});

  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    final response = await dio.post(
      endpoints['sign-in']!,
      data: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> tokens = response.data;

      return {
        "access_token": tokens["access_token"]!,
        "refresh_token": tokens["refresh_token"]!,
      };
    } else {
      throw Exception('Login failed: ${response.data['message']}');
    }
  }
}
