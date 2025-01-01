import 'package:dev2dev/core/config/api_config.dart';
import 'package:dev2dev/core/config/size_config.dart';
import 'package:dev2dev/core/widgets/custom_text_button.dart';
import 'package:dev2dev/features/profile/presentation/pages/profile_page.dart';
import 'package:dev2dev/features/registration/data/datasources/register_datasource.dart';
import 'package:dev2dev/features/registration/data/reg_repository_impl.dart';
import 'package:dev2dev/features/registration/domain/reg_repository.dart';
import 'package:dev2dev/features/registration/presentation/bloc/reg_validation_bloc/reg_validation_bloc.dart';
import 'package:dev2dev/features/registration/presentation/bloc/reg_validation_bloc/reg_validation_event.dart';
import 'package:dev2dev/features/registration/presentation/bloc/reg_validation_bloc/reg_validation_state.dart';
import 'package:dev2dev/features/registration/presentation/cubit/registration_cubit.dart';
import 'package:dev2dev/features/registration/presentation/cubit/registration_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  late DioClient dioClient;
  late RegRepository regRepo;
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController checkPasswordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  RegistrationPage() {
    dioClient = DioClient();
    regRepo = RegRepositoryImpl(RegisterDatasource(dioClient.dio));
  }

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  Future<void> register(String email, String password) async {
    await widget.regRepo.registerWithEmailAndPassword(email, password);
  }

  @override
  void didUpdateWidget(
      oldWidget) // Override it and copy the old ones over if not null
  {
    super.didUpdateWidget(oldWidget);
    if ((widget.emailController != null) && (oldWidget.emailController != null))
      widget.emailController.text = oldWidget.emailController.text;
    if ((widget.passwordController != null) &&
        (oldWidget.passwordController != null))
      widget.passwordController.text = oldWidget.passwordController.text;
    if ((widget.checkPasswordController != null) &&
        (oldWidget.checkPasswordController != null))
      widget.checkPasswordController.text =
          oldWidget.checkPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    double topPaddingHeight = ((SizeConfig.height(120) -
                (MediaQuery.of(context).viewInsets.bottom / 4)) >
            0
        ? SizeConfig.height(110) -
            (MediaQuery.of(context).viewInsets.bottom / 4)
        : 0);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegValidationBloc()),
        BlocProvider(create: (context) => RegistrationCubit(widget.regRepo)),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(18)),
          child: SingleChildScrollView(
            child: BlocListener<RegistrationCubit, RegistrationState>(
              listener: (context, state) => {
                if (state is RegSuccessState)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 700),
                        backgroundColor: Color.fromARGB(255, 86, 214, 114),
                        content: Center(
                          child: Text(
                            'Registered Succesfully!',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Future.delayed(const Duration(milliseconds: 500))
                        .then(Navigator.of(context).pop)
                  }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: topPaddingHeight,
                  ),
                  Text(
                    "Create an account",
                    style: GoogleFonts.overpass(
                        fontSize: SizeConfig.textSize(28),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: SizeConfig.height(44),
                  ),
                  TextField(
                    controller: widget.emailController,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(18),
                  ),
                  BlocBuilder<RegValidationBloc, RegValidationState>(
                      builder: (context, state) {
                    return TextField(
                      obscureText: true,
                      onChanged: (value) {
                        context.read<RegValidationBloc>().add(
                            RegValidationChanged(
                                password: widget.passwordController.text,
                                checkPassword:
                                    widget.checkPasswordController.text));
                      },
                      controller: widget.passwordController,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: SizeConfig.height(18),
                  ),
                  BlocBuilder<RegValidationBloc, RegValidationState>(
                      builder: (context, state) {
                    InputDecoration textFieldDecoration;
                    if (state is RegValidationInitial) {
                      textFieldDecoration = InputDecoration(
                        label: Text("Confirm password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    } else if (state is RegValidationError) {
                      textFieldDecoration = InputDecoration(
                        label: Text("Passwords must match!"),
                        labelStyle: TextStyle(color: Colors.red),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    } else {
                      textFieldDecoration = InputDecoration(
                        label: Text("Bingo! It's a match!"),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }

                    return TextField(
                        obscureText: true,
                        onChanged: (value) {
                          context.read<RegValidationBloc>().add(
                              RegValidationChanged(
                                  password: widget.passwordController.text,
                                  checkPassword:
                                      widget.checkPasswordController.text));
                        },
                        controller: widget.checkPasswordController,
                        decoration: textFieldDecoration);
                  }),
                  SizedBox(
                    height: SizeConfig.height(36),
                  ),
                  BlocBuilder<RegValidationBloc, RegValidationState>(
                      builder: (context, state) {
                    bool isButtonEnabled = false;
                    if (state is RegValidationSuccess) {
                      isButtonEnabled = true;
                    } else {
                      isButtonEnabled = false;
                    }

                    return BlocBuilder<RegistrationCubit, RegistrationState>(
                        builder: (context, state) {
                      return CustomTextButton(
                          onPressedFunction: isButtonEnabled &&
                                  state is! RegLoadingState
                              ? () {
                                  context
                                      .read<RegistrationCubit>()
                                      .registerWithEmail(
                                          widget.emailController.text.trim(),
                                          widget.passwordController.text);
                                }
                              : null,
                          buttonText: state is RegLoadingState
                              ? SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Sign up',
                                  style: GoogleFonts.overpass(
                                      fontSize: SizeConfig.textSize(16)),
                                ),
                          backgroundColor: const Color(0xFF5856D6),
                          foregroundColor: Colors.white);
                    });
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
