import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/MangaSlider.dart';
import 'package:m3ngon/api/get_manga_by_ranking.dart';
import 'package:m3ngon/components/error_screen.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/mangaorg.dart';

class WidgetMangaRank extends StatelessWidget {
  const WidgetMangaRank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getMangaByRankingTypeApi(rankingType: 'all', limit: 15),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    SizedBox(height: 100, width: 100, child: LoaderScreen()));
          }
          if (snapshot.data != null) {
            final List<Manga> mangas = List<Manga>.from(snapshot.data!);
            //return data
            return MangaSlider(mangaList: mangas);
          }
          return ErrorScreen(error: snapshot.error.toString());
        },
      ),
    );
  }
}
