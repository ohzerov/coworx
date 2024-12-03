import 'package:dev2dev/features/registration/domain/reg_repository.dart';

class RegisterUsecase {
  RegRepository regRepo;
  RegisterUsecase(this.regRepo);

  Future<String> execute(String email, String password) async {
    return await regRepo.registerWithEmailAndPassword(email, password);
  }
}
