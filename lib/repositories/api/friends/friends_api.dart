import 'package:dio/dio.dart';
import 'package:druna_app/repositories/api/main_api.dart';
import 'package:druna_app/repositories/models/friends.dart';

class FriendsApi {
  final _dio = MainApi().dio;

  Future<List<FriendInfo>> getFriendsList({required String token}) async {
    try {
      final response = await _dio.get(
        'http://192.168.31.176:22000/api/friends/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data["friends"];

        // Преобразуем JSON в список объектов FriendInfo
        final List<FriendInfo> friendsList = jsonData
            .map((json) => FriendInfo.fromJson(json))
            .toList();

        return friendsList;
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
