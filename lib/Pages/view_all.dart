import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/componentApi.dart/view_manga_list.dart';
import 'package:m3ngon/api/get_manga_by_ranking.dart';
import 'package:m3ngon/components/error_screen.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/mangaorg.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
      appBar: AppBar(
        title: Text(label),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getMangaByRankingTypeApi(
          rankingType: rankingType,
          limit: 500,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    SizedBox(height: 100, width: 100, child: LoaderScreen()));
          }
          if (snapshot.data != null) {
            return RMangaListView(
              mangas: List<Manga>.from(snapshot.data!),
            );
          }
          return ErrorScreen(error: snapshot.toString());
        },
      ),
    );
  }
}
