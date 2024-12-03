import 'package:dev2dev/core/config/constants.dart';
import 'package:dio/dio.dart';

class RegisterDatasource {
  Dio dio;
  RegisterDatasource(this.dio);

  Future<String> register(String email, String password) async {
    final response = await dio.post(
      endpoints['sign-up']!,
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.statusCode.toString();
  }
}
