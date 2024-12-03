import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/constants.dart';
import 'package:dev2dev/core/config/size_config.dart';
import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/core/widgets/custom_text_button.dart';
import 'package:dev2dev/features/auth/data/datasources/login_datasourse.dart';
import 'package:dev2dev/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dev2dev/features/auth/domain/usecases/login_usecase.dart';
import 'package:dev2dev/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<String> _fetchData() async {
    final storage = FlutterSecureStorage();
    final _token = await storage.read(key: "access_token");
    print(_token);
    final response = await DioClient().dio.get(endpoints["test"]!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ));

    if (response.statusCode == 200) {
      return response.data;
    } else {
      print(response.statusCode);
      return "No data";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
      future: _fetchData(),
      builder: (context, snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snaphot.hasData) {
          return Stack(
            children: [
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
                          "Welcome back!",
                          style: GoogleFonts.overpass(fontSize: 32),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height(32),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        snaphot.data.toString(),
                        style: GoogleFonts.overpass(fontSize: 22),
                      ),
                      SizedBox(
                        height: SizeConfig.height(16),
                      ),
                      SizedBox(
                        height: SizeConfig.height(16),
                      ),
                      Spacer(),
                      CustomTextButton(
                          onPressedFunction: () {
                            TokenMager(secureStorage: FlutterSecureStorage())
                                .deleteTokens();

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => App()));
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
              Lottie.asset(repeat: false, 'assets/lottie.json'),
            ],
          );
        } else {
          return Center(child: Text("No data"));
        }
      },
    )));
  }
}
