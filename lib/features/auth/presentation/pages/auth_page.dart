import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/size_config.dart';
import 'package:dev2dev/core/widgets/custom_text_button.dart';
import 'package:dev2dev/features/auth/data/datasources/login_datasourse.dart';
import 'package:dev2dev/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dev2dev/features/auth/domain/repositories/auth_repository.dart';
import 'package:dev2dev/features/auth/domain/usecases/login_usecase.dart';
import 'package:dev2dev/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dev2dev/features/auth/presentation/cubit/login_states.dart';
import 'package:dev2dev/features/profile/presentation/pages/profile_page.dart';
import 'package:dev2dev/features/registration/presentation/cubit/registration_state.dart';
import 'package:dev2dev/features/registration/presentation/pages/registration_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPage extends StatefulWidget {
  final LoginUsecase loginUsecase;
  final LoginRepo loginRepo;
  final LoginDatasourse loginDatasourse;
  final Dio dio;
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  AuthPage(this.dio, this.loginDatasourse, this.loginRepo, this.loginUsecase) {}

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void register(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegistrationPage()));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.emailController != null) && (oldWidget.emailController != null))
      widget.emailController.text = oldWidget.emailController.text;
    if ((widget.passwordController != null) &&
        (oldWidget.passwordController != null))
      widget.passwordController.text = oldWidget.passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    double topPaddingHeight = ((SizeConfig.height(120) -
                (MediaQuery.of(context).viewInsets.bottom / 4)) >
            0
        ? SizeConfig.height(120) -
            (MediaQuery.of(context).viewInsets.bottom / 4)
        : 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) => {
          if (state is LoginSuccessState)
            {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProfilePage()))
            }
          else if (state is LoginErrorState)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Color.fromARGB(255, 214, 86, 86),
                  content: Center(
                    child: Text(
                      'Please check your credentials!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(18)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: topPaddingHeight),
                  Text(
                    "Welcome to dev2dev!",
                    style: GoogleFonts.overpass(
                        fontSize: SizeConfig.textSize(28),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: SizeConfig.height(8),
                  ),
                  Text(
                    "Find any talent to collaborate with",
                    style: GoogleFonts.overpass(
                        fontSize: SizeConfig.textSize(18),
                        fontWeight: FontWeight.normal),
                  ),
                  // Spacer(),
                  SizedBox(
                    height: SizeConfig.height(44),
                  ),

                  TextField(
                    controller: widget.emailController,
                    onChanged: (value) {
                      print(value);
                    },
                    decoration: InputDecoration(
                      label: Text("Your email"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(18),
                  ),

                  TextField(
                    onChanged: (value) {
                      print(value);
                    },
                    controller: widget.passwordController,
                    obscuringCharacter: '\u2620',
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(36),
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                    return CustomTextButton(
                        onPressedFunction: state is! LoginLoadingState
                            ? () {
                                context.read<LoginCubit>().loginWithEmail(
                                    widget.emailController.text.trim(),
                                    widget.passwordController.text);
                              }
                            : null,
                        buttonText: state is LoginLoadingState
                            ? SizedBox(
                                width: 35,
                                height: 35,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Log in',
                                style: GoogleFonts.overpass(
                                    fontSize: SizeConfig.textSize(16)),
                              ),
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF5856D6));
                  }),
                  SizedBox(
                    height: SizeConfig.height(16),
                  ),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      SizedBox(
                        width: SizeConfig.width(25),
                      ),
                      Text('or'),
                      SizedBox(
                        width: SizeConfig.width(25),
                      ),
                      Expanded(child: Divider())
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(16),
                  ),

                  CustomTextButton(
                      onPressedFunction: () => register(context),
                      buttonText: Text(
                        'Sign up',
                        style: GoogleFonts.overpass(
                            fontSize: SizeConfig.textSize(16)),
                      ),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
