import 'dart:math';

import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/constants.dart';
import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?> _fetchData(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final _token = await TokenMager(secureStorage: storage).getAccessToken();

    final response = await DioClient().dio.get(endpoints["profile"]!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.data['nickname'];
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<void> logOut(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "access_token");
    final refreshToken = await storage.read(key: "refresh_token");

    final response = await DioClient().dio.post(endpoints["logout"]!,
        data: {"refresh_token": refreshToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

    if (response.statusCode == 200) {
      await TokenMager(secureStorage: FlutterSecureStorage()).deleteTokens();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => App()));
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
      ),
      backgroundColor: Colors.blue,
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 36)),
            );
          } else {
            return Center(
              child: ElevatedButton(
                  onPressed: () async {
                    logOut(context);
                  },
                  child: Text('logout')),
            );
          }
        },
      ),
    );
  }
}
