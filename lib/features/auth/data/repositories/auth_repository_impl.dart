import 'package:dev2dev/core/config/token_mager.dart';
import 'package:dev2dev/features/auth/data/datasources/login_datasourse.dart';
import 'package:dev2dev/features/auth/domain/repositories/auth_repository.dart';

class LoginRepoImpl implements LoginRepo {
  final LoginDatasourse loginDatasourse;
  final TokenMager? tokenManager;

  LoginRepoImpl({required this.loginDatasourse, this.tokenManager});
  @override
  Future<void> loginWithEmail(String email, String password) async {
    try {
      final tokens = await loginDatasourse.loginWithEmail(email, password);

      await tokenManager?.saveTokens(
          tokens['access_token']!, tokens['refresh_token']!);
      final token = await tokenManager?.getAccessToken();
      print(token);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
