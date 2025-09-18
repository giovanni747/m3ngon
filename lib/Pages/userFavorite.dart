import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_list.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_userList.dart';
import 'package:m3ngon/api/get_manga_details.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/manga_details.dart';

class UserFavoritePage extends StatelessWidget {
  const UserFavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3A380),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoaderScreen());
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('No Favoite Manga;('));
          }

          final List<dynamic> mangaIds =
              snapshot.data!.get('favorite_mangas') ?? [];
          if (mangaIds.isEmpty) {
            return const Center(child: Text('No Favoite Manga;('));
          }

          return FutureBuilder<List<MangaDetails>>(
            future: fetchMangaDetails(mangaIds.cast<int>()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(
                        width: 150, height: 150, child: LoaderScreen()));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No Manga Found'));
              }

              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.77,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final mangaDetails = snapshot.data![index];
                  return MangaUserTile(manga: mangaDetails);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<MangaDetails>> fetchMangaDetails(List<int> mangaIds) async {
    final List<MangaDetails> mangaDetailsList = [];

    for (final id in mangaIds) {
      try {
        final mangaDetails = await getMangaByDetailsApi(id: id);
        mangaDetailsList.add(mangaDetails);
      } catch (e) {
        print('Error fetching manga details for ID $id: $e');
      }
    }

    return mangaDetailsList;
  }
}
