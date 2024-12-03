import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/size_config.dart';
import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/features/auth/data/datasources/login_datasourse.dart';
import 'package:dev2dev/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dev2dev/features/auth/domain/usecases/login_usecase.dart';
import 'package:dev2dev/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dev2dev/features/auth/presentation/pages/auth_page.dart';
import 'package:dev2dev/features/profile/presentation/pages/profile_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  late Dio dio;
  late LoginDatasourse loginDatasourse;
  late LoginRepoImpl loginRepo;
  late LoginUsecase loginUsecase;
  late TokenMager tokenMager;
  late FlutterSecureStorage secureStorage;
  App() {
    dio = DioClient().dio;
    loginDatasourse = LoginDatasourse(dio: dio);
    secureStorage = FlutterSecureStorage();
    tokenMager = TokenMager(secureStorage: secureStorage);
    loginRepo = LoginRepoImpl(
        loginDatasourse: loginDatasourse, tokenManager: tokenMager);
    loginUsecase = LoginUsecase(loginRepo);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isLoggedin;
  bool isDone = false;
  Future<void> _checkUser() async {
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: 'access_token');
    setState(() {
      isLoggedin = token != null;
      isDone = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => LoginCubit(loginUsecase: widget.loginUsecase),
        child: isDone
            ? isLoggedin
                ? ProfilePage()
                : AuthPage(widget.dio, widget.loginDatasourse, widget.loginRepo,
                    widget.loginUsecase)
            : Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}


//AuthPage(dio, loginDatasourse, loginRepo, loginUsecase);


// FutureBuilder(
//           future: _checkUser(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             } else if (snapshot.hasData && snapshot.data == true) {
//               return ProfilePage();
//             } else {
//               return AuthPage(dio, loginDatasourse, loginRepo, loginUsecase);
//             }
//           },
//         ),