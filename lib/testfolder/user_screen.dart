import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/constants.dart';
import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/main.dart';
import 'package:dev2dev/testfolder/profile_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<void> logOut(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final accessToken =
        await TokenMager(secureStorage: storage).getAccessToken();

    final refreshToken =
        await TokenMager(secureStorage: storage).getRefreshToken();

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

  Future<String> _fetchData(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final token = await TokenMager(secureStorage: storage).getAccessToken();

    final response = await DioClient().dio.get(endpoints["users"]!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));

    if (response.isRedirect) {
      throw Exception("redirect");
    }

    if (response.statusCode == 200) {
      return response.data['nickname'];
    } else {
      print(response.statusCode);
      return "No data";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
      ),
      backgroundColor: Colors.green,
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data!,
                  style: TextStyle(color: Colors.white, fontSize: 36)),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            if (snapshot.error.toString().contains("redirect")) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            }
            return SizedBox.shrink();
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
