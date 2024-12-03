import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenMager {
  final FlutterSecureStorage secureStorage;
  TokenMager({required this.secureStorage});

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await secureStorage.write(key: 'access_token', value: accessToken);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refresh_token');
  }

  Future<void> deleteTokens() async {
    return await secureStorage.deleteAll();
  }
}
