import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cat_model.dart';
import 'package:flutter/foundation.dart';
class CatApiService {
  static const String _baseUrl =
      'https://api.thecatapi.com/v1/images/search?has_breeds=1';

  static const String _apiKey =
      'live_YLLMC4i1UwJ8xf47L3xQi3Ib2jULpPwdsC0GyTJs58PCrGUQ4Kbdm1LYm5U9n8T4';
  static Future<Cat?> fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'x-api-key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var item in data) {
          Cat cat = Cat.fromJson(item);
          if (cat.breed != null) {
            return cat;
          }
        }
      } else {
        debugPrint('Ошибка при запросе к API. Код ответа: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Произошла ошибка при загрузке кота: $e');
    }
    return null;
  }
}
