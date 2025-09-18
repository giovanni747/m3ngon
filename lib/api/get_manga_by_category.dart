import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m3ngon/models/manga_info.dart';

Future<String> getCategoryPictureApi({
  required String category,
}) async {
  final baseUrl =
      'https://api.myanimelist.net/v2/manga/ranking?ranking_type=$category&limit=4';

  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': 'e178c6dd9c9cee1301b18a8ad34e9c49',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final mangas = MangaInfo.fromJson(data);
    final mainPicture = mangas.mangas.first.node.mainPicture.large;

    return mainPicture;
  } else {
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
