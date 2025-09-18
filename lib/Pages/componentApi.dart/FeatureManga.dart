import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:m3ngon/Pages/componentApi.dart/MangaTile.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';
import 'package:m3ngon/Pages/view_all.dart';
import 'package:m3ngon/api/get_manga_by_ranking.dart';
import 'package:m3ngon/components/error_screen.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/mangaorg.dart';

class FeaturedManga extends StatelessWidget {
  const FeaturedManga({
    super.key,
    required this.rankingType,
    required this.label,
  });

  final String rankingType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMangaByRankingTypeApi(rankingType: rankingType, limit: 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(height: 100, width: 100, child: LoaderScreen()));
        }
        if (snapshot.data != null) {
          final List<Manga> mangaList = List<Manga>.from(snapshot.data!);
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      SizedBox(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ViewAll(
                                          rankingType: rankingType,
                                          label: label,
                                        )));
                              },
                              child: const Text("View All"))),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final manga = mangaList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MangaDes(id: manga.node.id),
                            ),
                          );
                        },
                        child: MangaTile(
                          manga: manga,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                    itemCount: mangaList.length),
              ),
            ],
          );
        }
        return ErrorScreen(error: snapshot.toString());
      },
    );
  }
}
