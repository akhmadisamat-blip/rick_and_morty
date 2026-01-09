import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ygroup/data/entity/episode.entity.dart';

class EpisodeRepository {
  static const _api = "https://rickandmortyapi.com/api";

  static Future<List<Episode>> getEpisodeList({required int page}) async {
    try {
      final url = "$_api/episode?page=$page";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final results = jsonData['results'] as List;
        return results.map((e) => Episode.fromJson(e)).toList();
      }
      throw ("Code: ${response.statusCode}");
    } catch (e) {
      throw ("Error: $e");
    }
  }
}
