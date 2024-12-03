import 'package:dev2dev/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  LoginRepo loginRepo;
  LoginUsecase(this.loginRepo);

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await loginRepo.loginWithEmail(email, password);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
