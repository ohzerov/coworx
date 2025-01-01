import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/constants.dart';
import 'package:dev2dev/core/config/size_config.dart';
import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/core/widgets/custom_text_button.dart';
import 'package:dev2dev/main.dart';
import 'package:dev2dev/testfolder/profile_screen.dart';
import 'package:dev2dev/testfolder/user_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _fetchData(BuildContext context) async {
    final storage = FlutterSecureStorage();

    final token = await TokenMager(secureStorage: storage).getAccessToken();

    final response = await DioClient().dio.get(endpoints["profile"]!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<void> logOut(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final accessToken = TokenMager(secureStorage: storage).getAccessToken();
    final refreshToken = TokenMager(secureStorage: storage).getRefreshToken();

    await TokenMager(secureStorage: storage).deleteTokens();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => App()));

    // final response = await DioClient().dio.post(endpoints["logout"]!,
    //     data: {"refresh_token": refreshToken},
    //     options: Options(
    //       headers: {
    //         'Authorization': 'Bearer $accessToken',
    //       },
    //     ));

    // if (response.statusCode == 200) {
    //   await TokenMager(secureStorage: storage).deleteTokens();

    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) => App()));
    // } else {
    //   print(response.statusCode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
      future: _fetchData(context),
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snaphot.hasData) {
          return Stack(
            children: [
              Lottie.asset(repeat: false, 'assets/lottie.json'),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.height(200),
                      ),
                      Text(
                        "🎉",
                        style: GoogleFonts.overpass(fontSize: 100),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Welcome back! \n ${snaphot.data!['nickname']}",
                          style: GoogleFonts.overpass(fontSize: 28),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height(32),
                      ),
                      CustomTextButton(
                          onPressedFunction: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserScreen()));
                          },
                          buttonText: Text(
                            'Check user',
                            style: GoogleFonts.overpass(
                                fontSize: SizeConfig.textSize(16)),
                          ),
                          backgroundColor: Color.fromARGB(255, 86, 214, 107),
                          foregroundColor: Colors.white),
                      Spacer(),
                      CustomTextButton(
                          onPressedFunction: () {
                            logOut(context);
                          },
                          buttonText: Text(
                            'Log out',
                            style: GoogleFonts.overpass(
                                fontSize: SizeConfig.textSize(16)),
                          ),
                          backgroundColor: Color(0xFF5856D6),
                          foregroundColor: Colors.white),
                      SizedBox(
                        height: SizeConfig.height(8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: ElevatedButton(
                onPressed: () async {
                  await TokenMager(secureStorage: FlutterSecureStorage())
                      .deleteTokens();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => App()));
                },
                child: Text('go back')),
          );
        }
      },
    )));
  }
}
