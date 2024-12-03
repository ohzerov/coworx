import 'package:dev2dev/features/registration/data/datasources/register_datasource.dart';
import 'package:dev2dev/features/registration/domain/reg_repository.dart';

class RegRepositoryImpl implements RegRepository {
  final RegisterDatasource registerDatasource;
  RegRepositoryImpl(this.registerDatasource);
  @override
  Future<String> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await registerDatasource.register(email, password);
    } catch (e) {
      throw Exception('Не удалось войти');
    }
  }
}
