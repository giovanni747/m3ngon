import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';

import 'package:m3ngon/models/mangaorg.dart';
import 'package:carousel_animations/carousel_animations.dart';

class MangaSlider extends StatelessWidget {
  const MangaSlider({Key? key, required this.mangaList}) : super(key: key);
  final List<Manga> mangaList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Height of the container
      child: Swiper(
        autoplay: true,
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          return TopContainerPicture(
            manga: manga,
          );
        },
        itemCount: mangaList.length, // Number of items in the list
        layout: SwiperLayout.STACK,
        itemWidth: 250,
        itemHeight: 300.0,
      ),
    );
  }
}

class TopContainerPicture extends StatelessWidget {
  const TopContainerPicture({
    super.key,
    required this.manga,
  });
  final Manga manga;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MangaDes(id: manga.node.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.network(
          manga.node.mainPicture.medium,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
