import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m3ngon/Pages/SearchPage.dart';
import 'package:m3ngon/Pages/componentApi.dart/FeatureManga.dart';
import 'package:m3ngon/Pages/futureForMangaR.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/helper/post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => ExplorePageState();
}

final FirestoreDatabase database = FirestoreDatabase();
String? _downloadUrl;
Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDetailsStream() {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .snapshots();
  } else {
    throw Exception("User not authenticated");
  }
}

// API e178c6dd9c9cee1301b18a8ad34e9c49
// curl "https://api.myanimelist.net/v2/anime?q=one&limit=4" -H "X-MAL-CLIENT-ID: e178c6dd9c9cee1301b18a8ad34e9c49"
// curl 'https://api.myanimelist.net/v2/manga?q=berserk' -H "X-MAL-CLIENT-ID: e178c6dd9c9cee1301b18a8ad34e9c49"
// curl 'https://api.myanimelist.net/v2/manga/2?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_volumes,num_chapters,authors{first_name,last_name},pictures,background,related_anime,related_manga,recommendations,serialization{name}' \-H "X-MAL-CLIENT-ID: e178c6dd9c9cee1301b18a8ad34e9c49"
class ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getUserDetailsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    SizedBox(height: 100, width: 100, child: LoaderScreen()));
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();
            _downloadUrl = user?['profilePicture'] ??
                "https://miro.medium.com/v2/resize:fill:96:96/1*U_PPMSbzapJdZu_CPSX7yQ.gif";
            return Scaffold(
              backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SearchPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              child:
                                  LottieBuilder.asset("images/searchIcon.json"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black,
                              border: Border.all(
                                color: Color(0xFFA3A380), // Border color
                                width: 7, // Border width
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                _downloadUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 290,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(128, 161, 193, 1.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 9,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Hello, ",
                                        style: GoogleFonts.rubikMonoOne(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              letterSpacing: .1,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      Text(
                                        user?['username'],
                                        style: GoogleFonts.rubikMonoOne(
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              letterSpacing: .7,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Keep Exploring",
                                      style: GoogleFonts.rubikMonoOne(
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            letterSpacing: .7,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Container(
                            width: 200,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromRGBO(238, 227, 171, 1.0),
                            ),
                            child: Center(
                              child: Text(
                                "Trending post",
                                style: GoogleFonts.rubikMonoOne(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      letterSpacing: .3,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                      ),
                      StreamBuilder(
                          stream: database.getPostsStream(),
                          builder: (context, snapshot) {
                            final posts = snapshot.data!.docs;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: LoaderScreen()));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data == null || posts.isEmpty) {
                              return Center(
                                child: Text("No posts.....Post Something!!!"),
                              );
                            } else if (snapshot.hasData) {
                              return Column(
                                children: [
                                  const SizedBox(height: 37),
                                  SizedBox(
                                    width: 350,
                                    height: 230,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: posts.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 17);
                                        },
                                        itemBuilder: (context, index) {
                                          final post = posts[index];

                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color.fromARGB(
                                                  255, 163, 163, 139),
                                            ),
                                            child: SizedBox(
                                              height: 180,
                                              width:
                                                  310, // Set the width of each item
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 15,
                                                    left: 15,
                                                    child: Container(
                                                      width: 65,
                                                      height: 65,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        color: Colors.white,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: post[
                                                              'profilePic'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 20,
                                                    left: 94,
                                                    child: Text(
                                                        post['mangaREF'],
                                                        overflow: TextOverflow
                                                            .ellipsis, // This ensures text ends with "..." if it overflows
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800)),
                                                  ),
                                                  Positioned(
                                                      top: 50,
                                                      left: 94,
                                                      child: Text(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          "@" + post['user'])),
                                                  Positioned(
                                                    top: 97,
                                                    left: 15,
                                                    right: 15,
                                                    child: Container(
                                                      width: 300,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: const Color
                                                            .fromRGBO(
                                                            254, 250, 224, 1.0),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 5),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: Text(
                                                              post[
                                                                  'PostMessage'],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              );
                            }
                            return const Text("No data");
                          }),
                      const SizedBox(height: 70),
                      Text(
                        "Top Ranked",
                        style: GoogleFonts.rubikMonoOne(
                          textStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              letterSpacing: .9,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(
                        height: 370,
                        child: WidgetMangaRank(),
                      ),
                      const SizedBox(
                        height: 350,
                        child: FeaturedManga(
                          label: 'Top Manhua',
                          rankingType: 'manhua',
                        ),
                      ),
                      const SizedBox(
                        height: 350,
                        child: FeaturedManga(
                          label: 'Most Popular',
                          rankingType: 'bypopularity',
                        ),
                      ),
                      const SizedBox(
                        height: 350,
                        child: FeaturedManga(
                          label: 'Top Novels',
                          rankingType: 'novels',
                        ),
                      ),
                      const SizedBox(
                        height: 400,
                        child: FeaturedManga(
                          label: 'Top Manhwa',
                          rankingType: 'manhwa',
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Logout')),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("No data");
          }
        });
  }
}
