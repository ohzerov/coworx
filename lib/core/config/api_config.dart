import 'package:dev2dev/core/config/constants.dart';
import 'package:dio/dio.dart';

class DioClient {
  late Dio dio;
  DioClient() {
    dio = Dio(BaseOptions(baseUrl: apiUrl));
  }
}
