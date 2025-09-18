import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_animations/carousel_animations.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';
import 'package:m3ngon/api/get_manga_details.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/mangaorg.dart';
import 'package:m3ngon/models/manga_details.dart'; // Import MangaDetails

class LibrarySlider extends StatelessWidget {
  const LibrarySlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Text('No Manga Liked ;(');
        }

        final List<dynamic> mangaIds = snapshot.data!.get('mangaList') ?? [];

        return FutureBuilder<List<MangaDetails>>(
          future: fetchMangaDetails(mangaIds.cast<int>()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderScreen();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final List<MangaDetails> mangaDetailsList = snapshot.data!;

            return SizedBox(
              height: 300,
              child: Swiper(
                autoplay: true,
                itemBuilder: (context, index) {
                  final mangaDetails = mangaDetailsList[index];
                  return TopContainerPicture(mangaDetails: mangaDetails);
                },
                itemCount: mangaDetailsList.length,
                layout: SwiperLayout.STACK,
                itemWidth: 250,
                itemHeight: 300.0,
              ),
            );
          },
        );
      },
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

class TopContainerPicture extends StatelessWidget {
  const TopContainerPicture({
    Key? key,
    required this.mangaDetails,
  }) : super(key: key);

  final MangaDetails mangaDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MangaDes(id: mangaDetails.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.network(
          mangaDetails
              .mainPicture.medium, // Assuming mainPicture is a URL string
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
