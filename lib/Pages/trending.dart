import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_animations/carousel_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/AI_Page.dart';
import 'package:m3ngon/Pages/componentApi.dart/manga_description.dart';
import 'package:m3ngon/api/get_manga_details.dart';
import 'package:m3ngon/components/loadingPage.dart';
import 'package:m3ngon/helper/post.dart';
import 'package:m3ngon/models/manga_details.dart';

final FirestoreDatabase database = FirestoreDatabase();

class TrendPage extends StatefulWidget {
  TrendPage({super.key});

  final controller = TextEditingController();
  final mangaController = TextEditingController();
  void postPo() {
    String mangaC = mangaController.text;
    if (controller.text.isNotEmpty) {
      String message = controller.text;
      database.addPost(message, mangaC);
    }
    controller.clear();
    mangaController.clear();
  }

  @override
  State<TrendPage> createState() => _TrendPageState();
}

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

String? _downloadUrlProfile;
String? _downloadUrlUsers;
String? _downloadUrl2;

class _TrendPageState extends State<TrendPage> with TickerProviderStateMixin {
  late final Map<String, AnimationController> _controllerFollow = {};
  final ImagePicker _picker = ImagePicker();
  late final Map<String, AnimationController> _likeControllers = {};
  List<DocumentSnapshot>? usersData;
  String? _downloadUrl2;
  @override
  void initState() {
    super.initState();
    usersData?.forEach((user) {
      _likeControllers[user.id] = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });
    usersData?.forEach((user) {
      _controllerFollow[user.id] = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    _controllerFollow.values.forEach((controller) {
      controller.dispose();
    });
    _likeControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> uploadImage() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && user != null) {
      File file = File(image.path);
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('backgroundPic/${user.uid}')
            .putFile(file);

        String downloadUrl_2 = await snapshot.ref.getDownloadURL();

        // Update Firestore with the newly obtained download URL.
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'backgroundPic': downloadUrl_2, // Use the local variable directly
        }, SetOptions(merge: true));

        // Then update the local state to reflect the change.
        setState(() {
          _downloadUrl2 = downloadUrl_2;
        });

        // Optionally update the user's authentication profile
        await user.updatePhotoURL(_downloadUrl2);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  bool isLiked = false; // Initially, the content is not liked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 250, 224, 1.0),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      SizedBox(height: 100, width: 100, child: LoaderScreen()));
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              //Map<String, dynamic>? user = snapshot.data!.data();

              final users = snapshot.data!.docs;
              usersData = users;
              users.forEach((user) {
                if (!_likeControllers.containsKey(user.id)) {
                  _likeControllers[user.id] = AnimationController(
                    duration: const Duration(milliseconds: 600),
                    vsync: this,
                  );
                }
              });
              users.forEach((user) {
                if (!_controllerFollow.containsKey(user.id)) {
                  _controllerFollow[user.id] = AnimationController(
                    duration: const Duration(milliseconds: 800),
                    vsync: this,
                  );
                }
              });

              // Initialize animation controllers inside builder

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: getUserDetailsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: LoaderScreen()));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          Map<String, dynamic>? user = snapshot.data!.data();

                          // _downloadUrl = user?['backgroundPic'] ??
                          //     "https://miro.medium.com/v2/resize:fill:96:96/1*U_PPMSbzapJdZu_CPSX7yQ.gif";
                          _downloadUrlProfile = user?['profilePicture'] ??
                              "https://miro.medium.com/v2/resize:fill:96:96/1*U_PPMSbzapJdZu_CPSX7yQ.gif";
                          return SizedBox(
                            height: 300,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: user?['backgroundPic'] != null
                                      ? CachedNetworkImage(
                                          imageUrl: user?['backgroundPic']!,
                                          fit: BoxFit.fill)
                                      : LottieBuilder.asset(
                                          "images/gradientBa.json",
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                Positioned(
                                  left: 15,
                                  bottom: 45,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(55),
                                      color: Colors.black,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: Image.network(
                                        _downloadUrlProfile!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.account_circle,
                                                    size: 110),
                                      ),
                                    ),
                                  ),
                                ),
                                // Other positioned widgets can continue here
                                Positioned(
                                  left: 140,
                                  bottom: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Center(
                                              child: Container(
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'Post',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                            ),
                                            content: Container(
                                              width: 300,
                                              height: 180,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 20),
                                                    TextField(
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            214, 29, 77, 1.0),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      controller: widget
                                                          .mangaController,
                                                      cursorWidth: 5,
                                                      cursorHeight: 15,
                                                      maxLines: 1,
                                                      cursorColor:
                                                          const Color.fromARGB(
                                                              255, 171, 67, 30),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Manga",
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          254,
                                                                          250,
                                                                          224,
                                                                          1.0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          254,
                                                                          250,
                                                                          224,
                                                                          1.0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          color: Color.fromRGBO(
                                                              214, 29, 77, 1.0),
                                                        ),
                                                        fillColor: Colors.black,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    TextField(
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            214, 29, 77, 1.0),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      controller:
                                                          widget.controller,
                                                      cursorWidth: 5,
                                                      cursorHeight: 15,
                                                      maxLines:
                                                          2, // Limit text to a maximum of two lines
                                                      cursorColor:
                                                          const Color.fromARGB(
                                                              255, 171, 67, 30),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Post",
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          254,
                                                                          250,
                                                                          224,
                                                                          1.0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          color: Color.fromRGBO(
                                                              214, 29, 77, 1.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          254,
                                                                          250,
                                                                          224,
                                                                          1.0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        fillColor: Colors.black,
                                                        filled: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  widget.postPo();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  width: 70,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.black,
                                                  ),
                                                  child: const Center(
                                                    child: Text("submit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                      child: const Icon(Icons.add,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 15,
                                  bottom: 45,
                                  child: GestureDetector(
                                    onTap: () {
                                      uploadImage();
                                    },
                                    child: SizedBox(
                                        height: 35,
                                        child:
                                            Image.asset('images/picture.png')),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Text("No data available");
                        }
                      },
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            width: 160,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                            ),
                            child: Center(
                                child: Text(
                              "New Users",
                              style: GoogleFonts.rubikMonoOne(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w400),
                              ),
                            ))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                _downloadUrlUsers = user?['profilePicture'] ??
                                    "https://miro.medium.com/v2/resize:fill:96:96/1*U_PPMSbzapJdZu_CPSX7yQ.gif";
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (_) => MangaDes(id: manga.node.id),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        _downloadUrlUsers!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                            ),
                          ),
                        ],
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
                                const SizedBox(height: 60),
                                Container(
                                    width: 230,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Post or Takes",
                                      style: GoogleFonts.rubikMonoOne(
                                        textStyle: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ))),
                                const SizedBox(height: 20),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 420,
                                  height: 300,
                                  child: Flexible(
                                    child: CardSwiper(
                                        allowedSwipeDirection:
                                            const AllowedSwipeDirection.only(
                                                left: true, right: true),
                                        cardsCount: posts.length,
                                        cardBuilder: (context,
                                            index,
                                            percentThresholdX,
                                            percentThresholdY) {
                                          final post = posts[index];
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 55, 52, 52)
                                                      .withOpacity(
                                                          0.8), // Color of the shadow
                                                  spreadRadius:
                                                      1, // Spread radius
                                                  blurRadius: 7, // Blur radius
                                                  offset: const Offset(1,
                                                      7), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color.fromARGB(
                                                  255, 163, 163, 139),
                                            ),
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
                                                          BorderRadius.circular(
                                                              60),
                                                      color: Colors.white,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            post['profilePic'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 20,
                                                  left: 94,
                                                  child: Text(post['mangaREF'],
                                                      overflow: TextOverflow
                                                          .ellipsis, // This ensures text ends with "..." if it overflows
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                ),
                                                Positioned(
                                                    top: 50,
                                                    left: 94,
                                                    child: Text(
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        "@" + post['user'])),
                                                Positioned(
                                                  top: 97,
                                                  left: 20,
                                                  right: 20,
                                                  child: Container(
                                                    width: 300,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color:
                                                          const Color.fromRGBO(
                                                              254,
                                                              250,
                                                              224,
                                                              1.0),
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
                                                            post['PostMessage'],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Text("No data");
                        }),
                    const SizedBox(height: 80),
                    Column(
                      children: [
                        Container(
                            width: 160,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black),
                            child: Center(
                                child: Text(
                              "Explore",
                              style: GoogleFonts.rubikMonoOne(
                                textStyle: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w400),
                              ),
                            ))),
                        const SizedBox(height: 20),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 300,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: const Color.fromARGB(
                                            255, 163, 163, 139),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 10,
                                            left: 100,
                                            right: 100,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                color: Colors.black,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: CachedNetworkImage(
                                                  imageUrl: users[index]
                                                      ['profilePicture'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 19),
                                  Positioned(
                                      top: 115,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            '@' + users[index]['username'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      )),
                                  const SizedBox(height: 19),
                                  Positioned(
                                    top: 143,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 230,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromRGBO(
                                              254, 250, 224, 1.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      users[index]['following']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 12),
                                                    child: Text(
                                                      "following",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 7),
                                              const SizedBox(
                                                height: 30,
                                                child: VerticalDivider(
                                                  color: Color.fromARGB(
                                                      255, 163, 163, 139),
                                                  thickness: 1,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              GestureDetector(
                                                onTap: () {
                                                  final AnimationController
                                                      controller =
                                                      _likeControllers[
                                                          users[index].id]!;

                                                  // Toggle animation state
                                                  if (controller.isCompleted) {
                                                    controller.reverse();
                                                    isLiked =
                                                        false; // Content is unliked
                                                  } else {
                                                    controller.forward();
                                                    isLiked =
                                                        true; // Content is liked
                                                  }

                                                  // Update like count in Firestore
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(users[index].id)
                                                      .update({
                                                    'likeAmout': FieldValue
                                                        .increment(isLiked
                                                            ? 1
                                                            : -1), // Increment or decrement based on whether content is liked
                                                  });
                                                },
                                                child: LottieBuilder.asset(
                                                  "images/love.json",
                                                  controller: _likeControllers[
                                                      users[index].id],
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              const SizedBox(
                                                height: 30,
                                                child: VerticalDivider(
                                                  color: Color.fromARGB(
                                                      255, 163, 163, 139),
                                                  thickness: 1,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              SizedBox(
                                                height: 40,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final AnimationController
                                                        _controller2 =
                                                        _controllerFollow[
                                                            users[index].id]!;
                                                    _controller2.forward();

                                                    final currentUser =
                                                        FirebaseAuth.instance
                                                            .currentUser;
                                                    if (currentUser == null) {
                                                      print(
                                                          'User not logged in');
                                                      return;
                                                    }

                                                    final userRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(currentUser
                                                                .uid);
                                                    final userDoc =
                                                        await userRef.get();

                                                    // Retrieve the list of followed users from the current user's document
                                                    List<String> favoriteUsers = List<
                                                        String>.from(userDoc.get(
                                                            'following_users') ??
                                                        []);
                                                    final userId =
                                                        users[index].id;

                                                    // Toggle ID in the list
                                                    if (favoriteUsers
                                                        .contains(userId)) {
                                                      favoriteUsers.remove(
                                                          userId); // Remove if already present
                                                    } else {
                                                      favoriteUsers.add(
                                                          userId); // Add if not present
                                                    }

                                                    // Update the 'following_users' field in the user's document
                                                    await userRef.update({
                                                      'following_users':
                                                          favoriteUsers
                                                    });
                                                    final followingCount =
                                                        userDoc.get(
                                                                'following') ??
                                                            0;
                                                    await userRef.update({
                                                      'following':
                                                          followingCount + 1
                                                    });

                                                    if (_controller2.status ==
                                                        AnimationStatus
                                                            .completed) {
                                                      _controller2.reverse();
                                                    }
                                                  },
                                                  child: LottieBuilder.asset(
                                                    "images/follow.json",
                                                    controller:
                                                        _controllerFollow[
                                                            users[index].id],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<List<MangaDetails>>(
                                    future: fetchMangaDetails(
                                        users[index]['mangaList'].cast<int>()),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: LoaderScreen(),
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      if (snapshot.data == null ||
                                          snapshot.data!.isEmpty) {
                                        return const Text(
                                            'No manga details found.');
                                      }
                                      final List<MangaDetails>
                                          mangaDetailsList = snapshot.data!;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 190),
                                        child: SizedBox(
                                          height: 300,
                                          child: Swiper(
                                            autoplay: true,
                                            itemBuilder: (context, index) {
                                              final mangaDetails =
                                                  mangaDetailsList[index];
                                              return TopContainerPicture(
                                                mangaDetails: mangaDetails,
                                              );
                                            },
                                            itemCount: mangaDetailsList.length,
                                            layout: SwiperLayout.STACK,
                                            itemWidth: 170,
                                            itemHeight: 230,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Text("No data");
            }
          }),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AIAssistancePage()),
          );
        },
        child: Transform.scale(
          scale: 3.0, // Adjust scale factor as needed
          child: LottieBuilder.asset('images/AI.json'),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
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
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 55, 52, 52)
                  .withOpacity(0.8), // Color of the shadow
              spreadRadius: 1, // Spread radius
              blurRadius: 7, // Blur radius
              offset: const Offset(1, 10), // changes position of shadow
            ),
          ],
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
