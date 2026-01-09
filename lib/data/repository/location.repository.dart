import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ygroup/data/entity/location.entity.dart';

class LocationRepository {
  static const _api = "https://rickandmortyapi.com/api";

  static Future<List<Location>> getLocationList({required int page}) async {
    try {
      final url = "$_api/location?page=$page";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final results = jsonData['results'] as List;
        return results.map((e) => Location.fromJson(e)).toList();
      }
      throw ("Code: ${response.statusCode}");
    } catch (e) {
      throw ("Error: $e");
    }
  }
}
