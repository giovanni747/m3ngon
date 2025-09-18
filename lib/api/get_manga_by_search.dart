import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m3ngon/models/mangaorg.dart';

import '/models/manga_info.dart';

Future<Iterable<Manga>> getMangaBySearchApi({
  required String query,
}) async {
  final baseUrl = 'https://api.myanimelist.net/v2/manga?q=$query';
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': 'e178c6dd9c9cee1301b18a8ad34e9c49',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    MangaInfo mangaInfo = MangaInfo.fromJson(data);
    Iterable<Manga> mangas = mangaInfo.mangas;

    return mangas;
  } else {
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
