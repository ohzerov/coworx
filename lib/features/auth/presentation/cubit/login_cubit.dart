import 'package:dev2dev/features/auth/domain/usecases/login_usecase.dart';
import 'package:dev2dev/features/auth/presentation/cubit/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginUsecase loginUsecase;

  LoginCubit({required this.loginUsecase}) : super(LoginInitialState());

  Future<void> loginWithEmail(String email, String password) async {
    emit(LoginLoadingState());
    try {
      final response = await loginUsecase.loginWithEmail(email, password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(e.toString()));
      print(e);
    }
  }
}
