import 'package:dev2dev/features/registration/presentation/bloc/reg_validation_bloc/reg_validation_event.dart';
import 'package:dev2dev/features/registration/presentation/bloc/reg_validation_bloc/reg_validation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegValidationBloc extends Bloc<RegValidationEvent, RegValidationState> {
  RegValidationBloc() : super(RegValidationInitial()) {
    on<RegValidationChanged>(_regValidationChanged);
  }

  _regValidationChanged(
      RegValidationChanged event, Emitter<RegValidationState> emit) {
    if (event.password != event.checkPassword) {
      emit(RegValidationError());
    } else if (event.password == '' && event.checkPassword == '') {
      emit(RegValidationInitial());
    } else
      emit(RegValidationSuccess());
  }
}
