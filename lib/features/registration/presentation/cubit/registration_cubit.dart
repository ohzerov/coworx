import 'package:dev2dev/features/registration/domain/reg_repository.dart';
import 'package:dev2dev/features/registration/presentation/cubit/registration_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegRepository regRepo;
  RegistrationCubit(this.regRepo) : super(RegInitialState());

  Future<void> registerWithEmail(String email, String password) async {
    emit(RegLoadingState());
    try {
      String statusCode =
          await regRepo.registerWithEmailAndPassword(email, password);
      debugPrint(statusCode);
      if (statusCode == '201') {
        emit(RegSuccessState());
      }
    } catch (e) {
      emit(RegErrorState());
    }
  }
}
