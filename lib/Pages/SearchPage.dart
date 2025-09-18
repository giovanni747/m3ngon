import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/EPG.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_list.dart';
import 'package:m3ngon/api/get_manga_by_search.dart';
import 'package:m3ngon/models/manga_node.dart';
import 'package:m3ngon/models/mangaorg.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showSearch(context: context, delegate: MangaSearchDelegate());
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
      body: InkWell(
        onTap: () {
          showSearch(context: context, delegate: MangaSearchDelegate());
        },
        child: Center(
          child: Container(
            child: LottieBuilder.asset("images/loading.json"),
          ),
        ),
      ),
    );
  }
}

class MangaSearchDelegate extends SearchDelegate<List<MangaNode>> {
  List<Manga> mangas = [];
  Future searchManga(String query) async {
    final mangas = await getMangaBySearchApi(query: query);
    this.mangas = mangas.toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, []);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ExplorePage(),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchManga(query);
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Enter search query'),
      );
    } else {
      return FutureBuilder<Iterable<Manga>>(
        future: getMangaBySearchApi(query: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final mangas = snapshot.data ?? [];
            return SearchResultsView(mangas: mangas);
          }
        },
      );
    }
  }
}

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key, required this.mangas});
  final Iterable<Manga> mangas;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.all(8.0),
      child: ListView.builder(
        itemCount: mangas.length,
        itemBuilder: (context, index) {
          final manga = mangas.elementAt(index);

          return MangaListTile(manga: manga);
        },
      ),
    );
  }
}
//MangaListTile(manga: manga);