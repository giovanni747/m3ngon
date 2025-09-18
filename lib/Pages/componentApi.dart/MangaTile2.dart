import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m3ngon/models/manga_node.dart';

class SimilarTile extends StatelessWidget {
  const SimilarTile({
    super.key,
    required this.mangaNode,
  });
  final MangaNode mangaNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: mangaNode.mainPicture.medium,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mangaNode.title,
            maxLines: 3,
            style: TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
