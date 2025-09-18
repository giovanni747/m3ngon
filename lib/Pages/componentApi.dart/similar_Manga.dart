import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:m3ngon/Pages/componentApi.dart/MangaTile2.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';
import 'package:m3ngon/models/manga_node.dart';

class SimilarManga extends StatelessWidget {
  const SimilarManga({
    Key? key,
    required this.mangas,
    required this.label,
  }) : super(key: key);

  final List<MangaNode> mangas;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          child: Text(
            label,
            style: GoogleFonts.rubikMonoOne(
              textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  letterSpacing: .5,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: mangas.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              final mangaNode = mangas[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MangaDes(id: mangaNode.id),
                    ),
                  );
                },
                child: SimilarTile(
                  mangaNode: mangaNode,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
