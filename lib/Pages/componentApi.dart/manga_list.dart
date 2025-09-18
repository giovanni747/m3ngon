import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';
import 'package:m3ngon/models/mangaorg.dart';

class MangaListTile extends StatelessWidget {
  const MangaListTile({
    super.key,
    required this.manga,
    this.rank,
  });

  final Manga manga;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MangaDes(id: manga.node.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 202,
                height: 202,
                child: CachedNetworkImage(
                  imageUrl: manga.node.mainPicture.medium,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            rank != null
                ? MangaRankBadge(rank: rank!)
                : const SizedBox.shrink(),
            const SizedBox(height: 4),
            Text(
              manga.node.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class MangaRankBadge extends StatelessWidget {
  const MangaRankBadge({
    super.key,
    required this.rank,
  });

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.amberAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 3.0,
        ),
        child: Text(
          'Rank $rank',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
