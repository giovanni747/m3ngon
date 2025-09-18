import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m3ngon/models/manga_details.dart';

// import '/models/Manga.dart';

Future<MangaDetails> getMangaByDetailsApi({
  required int id,
}) async {
  final baseUrl =
      'https://api.myanimelist.net/v2/manga/$id?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_volumes,num_chapters,authors{first_name,last_name},pictures,background,related_anime,related_manga,recommendations,serialization{name}';
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {
      'X-MAL-CLIENT-ID': 'e178c6dd9c9cee1301b18a8ad34e9c49',
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final mangaDetails = MangaDetails.fromJson(data);
    return mangaDetails;
  } else {
    debugPrint("Error: ${response.statusCode}");
    debugPrint("Body: ${response.body}");
    throw Exception("Failed to get data!");
  }
}
