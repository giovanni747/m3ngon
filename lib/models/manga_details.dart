//id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity, num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,num_volumes,num_chapters,authors{first_name,last_name},pictures,related_anime,related_manga,recommendations,serialization{name}'

import 'package:flutter/foundation.dart' show immutable;
import '/models/picture.dart';
import '/models/manga_node.dart';

class MangaDetails {
  final int id;
  final String title;
  final Picture mainPicture;
  final AlternativeTitles alternativeTitles;
  final String startDate;
  final String endDate;
  final String synopsis;

  // Most of the times it's an int, but to avoid rare cases errors when it's
  // a double, define "mean" as dynamic
  final dynamic mean;
  final int rank;
  final int popularity;
  final String createdAt;
  final String updatedAt;
  final String mediaType;
  final List<Genre> genres;
  final List<Picture> pictures;
  final List<RelatedManga> relatedManga;
  final List<Recommendation> recommendations;

  const MangaDetails({
    required this.id,
    required this.title,
    required this.mainPicture,
    required this.alternativeTitles,
    required this.startDate,
    required this.endDate,
    required this.synopsis,
    required this.mean,
    required this.rank,
    required this.popularity,
    required this.createdAt,
    required this.updatedAt,
    required this.mediaType,
    required this.genres,
    required this.recommendations,
    required this.relatedManga,
    required this.pictures,
  });

  factory MangaDetails.fromJson(Map<String, dynamic> json) {
    return MangaDetails(
      id: json['id'],
      title: json['title'],
      mainPicture: Picture.fromJson(json['main_picture']),
      alternativeTitles: AlternativeTitles.fromJson(json['alternative_titles']),
      startDate: json['start_date'] ?? 'Unknown',
      endDate: json['end_date'] ?? 'Unknown',
      synopsis: json['synopsis'],
      mean: json['mean'] ?? 0.0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      mediaType: json['media_type'],
      genres: List<Genre>.from(
        json['genres'].map(
          (genre) => Genre.fromJson(genre),
        ),
      ),
      relatedManga: List<RelatedManga>.from(
        json['related_manga'].map(
          (related) => RelatedManga.fromJson(related),
        ),
      ),
      recommendations: List<Recommendation>.from(
        json['recommendations'].map(
          (rec) => Recommendation.fromJson(rec),
        ),
      ),
      pictures: List<Picture>.from(
        json['pictures'].map(
          (picture) => Picture.fromJson(picture),
        ),
      ),
    );
  }
}

@immutable
class AlternativeTitles {
  final List<String> synonyms;
  final String en;
  final String ja;

  const AlternativeTitles({
    required this.synonyms,
    required this.en,
    required this.ja,
  });

  factory AlternativeTitles.fromJson(Map<String, dynamic> json) {
    return AlternativeTitles(
      synonyms: List<String>.from(json['synonyms']),
      en: json['en'],
      ja: json['ja'],
    );
  }
}

@immutable
class Genre {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

@immutable
class RelatedManga {
  final MangaNode node;
  final int id;
  final String title;

  const RelatedManga({
    required this.node,
    required this.id,
    required this.title,
  });

  factory RelatedManga.fromJson(Map<String, dynamic> json) {
    return RelatedManga(
      node: MangaNode.fromJson(json['node']),
      id: json['node']['id'],
      title: json['node']['title'],
    );
  }
}

@immutable
class Recommendation {
  final MangaNode node;
  final int id;
  final String title;

  const Recommendation({
    required this.node,
    required this.id,
    required this.title,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      node: MangaNode.fromJson(json['node']),
      id: json['node']['id'],
      title: json['node']['title'],
    );
  }
}
// @immutable
// class RelatedAnime {
//   final MangaNode node;
//   final String relationType;
//   final String relationTypeFormatted;

//   const RelatedAnime({
//     required this.node,
//     required this.relationType,
//     required this.relationTypeFormatted,
//   });

//   factory RelatedAnime.fromJson(Map<String, dynamic> json) {
//     return RelatedAnime(
//       node: AnimeNode.fromJson(json['node']),
//       relationType: json['relation_type'],
//       relationTypeFormatted: json['relation_type_formatted'],
//     );
//   }
// }