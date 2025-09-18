import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_list.dart';
import 'package:m3ngon/models/manga_details.dart'; // Adjust the import as per your project structure
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';

class MangaUserTile extends StatelessWidget {
  const MangaUserTile({
    super.key,
    required this.manga,
    this.rank,
  });

  final MangaDetails manga; // Change to MangaDetails
  final int? rank;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                MangaDes(id: manga.id), // Assume manga.id is correct
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
                  imageUrl: manga.mainPicture.medium, // Adjusted field name
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
              manga.title, // Adjusted field name
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
