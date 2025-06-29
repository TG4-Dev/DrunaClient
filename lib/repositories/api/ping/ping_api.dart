import 'package:dio/dio.dart';
import 'package:druna_app/repositories/api/main_api.dart';

class PingApi {
  final dio = MainApi().dio;

  Future<void> ping() async {
    try {
      final response = await dio.get(
        'http://192.168.31.176:22000/ping/',
        // 'https://postman-echo.com/get',
      );

      if (response.statusCode == 200) {
        print(response.data);
        return;
      } else {
        throw Exception(
          'Ошибка при получении списка друзей: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Ошибка Dio: ${e.message}');
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}
