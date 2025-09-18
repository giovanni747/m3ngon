import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_list.dart';
import 'package:m3ngon/models/mangaorg.dart';

class RMangaListView extends StatelessWidget {
  const RMangaListView({super.key, required this.mangas});
  final List<Manga> mangas;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: mangas.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 0.77, // Aspect ratio (width / height)
        crossAxisSpacing: 8, // Horizontal space between children
        mainAxisSpacing: 8, // Vertical space between children
      ),
      itemBuilder: (context, index) {
        final manga = mangas[index];
        return MangaListTile(
          manga: manga,
        );
      },
    );
  }
}
