import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/mangaorg.dart';

Future<Iterable<Manga>> getMangaByRankingTypeApi({
  required String rankingType,
  required int limit,
}) async {
  final baseUrl =
      'https://api.myanimelist.net/v2/manga/ranking?ranking_type=$rankingType&limit=$limit';
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': 'e178c6dd9c9cee1301b18a8ad34e9c49',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> mangaNodeList = data['data'];
    final mangas = mangaNodeList
        .where((MangaNode) => MangaNode['node']['main_picture'] != null)
        .map(
      (node) {
        return Manga.fromJson(node);
      },
    );
    return mangas;
  } else {
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
