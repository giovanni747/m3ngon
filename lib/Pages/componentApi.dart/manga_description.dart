import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_animations/carousel_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/componentApi.dart/info_text.dart';
import 'package:m3ngon/Pages/componentApi.dart/reads_more.dart';
import 'package:m3ngon/Pages/componentApi.dart/similar_Manga.dart';
import 'package:m3ngon/api/get_manga_details.dart';
import 'package:m3ngon/components/backIcon.dart';
import 'package:m3ngon/components/error_screen.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/models/manga_details.dart';
import 'package:m3ngon/models/picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MangaDes extends StatefulWidget {
  MangaDes({super.key, required this.id});

  final int id;

  @override
  State<MangaDes> createState() => _MangaDesState();
}

class _MangaDesState extends State<MangaDes> with TickerProviderStateMixin {
  late final AnimationController _controllerHeart;

  late final AnimationController _controllerFavorite;

  @override
  void initState() {
    super.initState();
    _controllerHeart =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerFavorite =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    if (_controllerHeart.isAnimating) {
      _controllerHeart.stop();
    }
    if (_controllerFavorite.isAnimating) {
      _controllerFavorite.stop();
    }

    _controllerHeart.dispose();
    _controllerFavorite.dispose();

    super.dispose();
  }

  void _addToFavoriteList(int id) async {
    // Get current user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('User not logged in');
      return;
    }

    // Update user document in Firestore
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userDoc = await userRef.get();
    final favoriteMangas = List<int>.from(userDoc.get('favorite_mangas') ?? []);

    if (favoriteMangas.contains(id)) {
      // Remove from favorite list
      favoriteMangas.remove(id);
      // Reverse animation
      _controllerFavorite.reverse();
    } else {
      // Add to favorite list
      favoriteMangas.add(id);
      // Forward animation
      _controllerFavorite.forward();
    }

    await userRef.update({
      'favorite_mangas': favoriteMangas,
    });
  }

  void _addToUserList(int id) async {
    // Get current user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('User not logged in');
      return;
    }

    // Update user document in Firestore
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userDoc = await userRef.get();
    final likedMangas = List<int>.from(userDoc.get('mangaList') ?? []);

    if (likedMangas.contains(id)) {
      // Remove from favorite list
      likedMangas.remove(id);
      // Reverse animation
      _controllerHeart.reverse();
    } else {
      // Add to favorite list
      likedMangas.add(id);
      // Forward animation
      _controllerHeart.forward();
    }

    await userRef.update({
      'mangaList': likedMangas,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMangaByDetailsApi(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    SizedBox(height: 100, width: 100, child: LoaderScreen()));
          }
          if (snapshot.data != null) {
            final manga = snapshot.data!;

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMangaImage(imageUrl: manga.mainPicture.large),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          Align(
                            alignment: Alignment.center,
                            child: _buildMangaTitle(
                              name: manga.title,
                              englishname: manga.alternativeTitles.en,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Container(
                                width: 115,
                                height: 59,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromRGBO(
                                        160, 206, 217, 1.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _addToUserList(widget.id);
                                          },
                                          child: LottieBuilder.asset(
                                            "images/love.json",
                                            controller: _controllerHeart,
                                          )),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          _addToFavoriteList(widget.id);
                                        },
                                        child: Container(
                                          height: 40,
                                          child: LottieBuilder.asset(
                                            "images/favoritee.json",
                                            controller: _controllerFavorite,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Description
                          const SizedBox(height: 40),
                          ReadMoreText(
                            longText: manga.synopsis,
                          ),

                          _buildMangaInfo(
                            manga: manga,
                          ),
                          const SizedBox(height: 10),
                          _buildImageGallery(images: manga.pictures),
                          const SizedBox(height: 100),
                          SimilarManga(
                              mangas: manga.relatedManga
                                  .map((mangaRel) => mangaRel.node)
                                  .toList(),
                              label: 'Related Manga'),
                          // have to do null checks
                          const SizedBox(height: 30),
                          SimilarManga(
                              mangas: manga.recommendations
                                  .map((mangaRec) => mangaRec.node)
                                  .toList(),
                              label: 'Recommendations'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return ErrorScreen(error: snapshot.toString());
        });
  }

  _buildMangaImage({
    required String imageUrl,
  }) =>
      Stack(
        children: [
          CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity),
          const Positioned(
            top: 30,
            left: 20,
            child: BackButton(),
          ),
        ],
      );

  Widget _buildMangaTitle({
    required String name,
    required String englishname,
  }) =>
      Builder(builder: (context) {
        return Text(
          name,
          style: GoogleFonts.rubikMonoOne(
            textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.w400),
          ),
        );
      });

  Widget _buildImageGallery({
    required List<Picture> images,
  }) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text(
          'Cover Art',
          style: GoogleFonts.rubikMonoOne(
            textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: .3,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 300, // Height of the container
          child: Swiper(
            autoplay: true,
            itemBuilder: (context, index) {
              final image = images[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(image.medium, fit: BoxFit.contain),
              );
            },
            itemCount: images.length,
            layout: SwiperLayout.STACK,
            itemWidth: 250,
            itemHeight: 300.0,
          ),
        )
      ],
    );
  }

  Widget _buildMangaInfo({
    required MangaDetails manga,
  }) {
    String genres = manga.genres.map((genre) => genre.name).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        // InfoText(label: 'Genres: ', info: genres),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genres:',
              style: GoogleFonts.rubikMonoOne(
                textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    letterSpacing: .3,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
                height: 6), // Add some spacing between label and genres

            // Split the genres string and create a container for each genre
            Wrap(
              spacing: 8, // Adjust the spacing between containers
              children: manga.genres.map((genre) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(238, 227, 171, 1.0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      genre.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 40),
        //InfoText(label: 'Start date: ', info: manga.startDate),

        // InfoText(label: 'End date: ', info: manga.endDate),
        // InfoText(label: 'Japanese Name: ', info: manga.alternativeTitles.ja),
      ],
    );
  }
}
