import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_animations/carousel_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/Friends_page.dart';
import 'package:m3ngon/Pages/userFavorite.dart';
import 'package:m3ngon/Pages/userLike.dart';
import 'package:m3ngon/components/library.dart';
import 'package:m3ngon/components/loadingPage.dart';
// import 'package:m3ngon/components/bio_text.dart';
import 'package:m3ngon/components/my_silver_app.dart';
import 'package:m3ngon/components/my_tab_bar.dart';

// ignore: camel_case_types
class accountPage extends StatefulWidget {
  accountPage({super.key});

  @override
  State<accountPage> createState() => _accountPageState();
}

class _accountPageState extends State<accountPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final AnimationController _controllerHeart;

  //Uint8List? _image;
  final ImagePicker _picker = ImagePicker();
  String? _downloadUrl;
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controllerHeart = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_controllerHeart.isAnimating) {
      _controllerHeart.stop();
    }
    _controllerHeart.dispose();
    super.dispose();
  }

  Future<void> uploadImage() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && user != null) {
      File file = File(image.path);
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('profilePictures/${user.uid}')
            .putFile(file);

        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the newly obtained download URL.
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'profilePicture': downloadUrl, // Use the local variable directly
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Then update the local state to reflect the change.
        setState(() {
          _downloadUrl = downloadUrl;
        });

        // Optionally update the user's authentication profile
        await user.updatePhotoURL(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  // future to fetch user detail
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  MySilverAppBar(
                      title: MyTabBar(
                        tabController: _tabController,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 83),
                              child: Center(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 190,
                                      height: 190,
                                      child: Container(
                                        width: 105,
                                        height: 105,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: const Color.fromRGBO(
                                              214, 206, 147, 1.0),
                                          border: Border.all(
                                            color: const Color(
                                                0xFFA3A380), // Border color
                                            width: 10, // Border width
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: _downloadUrl != null
                                              ? Image.network(
                                                  _downloadUrl!,
                                                  fit: BoxFit.cover,
                                                  width: 105,
                                                  height: 105,
                                                )
                                              : Image.network(
                                                  "https://miro.medium.com/v2/resize:fill:96:96/1*U_PPMSbzapJdZu_CPSX7yQ.gif",
                                                  fit: BoxFit.cover,
                                                  width: 105,
                                                  height: 105,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          uploadImage();
                                        },
                                        child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA3A380),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.white,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 14),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "@" +
                                            (user?['username'] ??
                                                'Unknown User'),
                                        style: const TextStyle(
                                          fontSize: 19,
                                          color: Color.fromARGB(
                                              255, 163, 163, 139),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              user?['following']?.toString() ??
                                                  '0',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFFA3A380),
                                              ),
                                            ),
                                            const Text(
                                              "Following",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFA3A380),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 50),
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 163, 163, 139),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (_controllerHeart.status !=
                                                      AnimationStatus
                                                          .completed) {
                                                    _controllerHeart.forward();
                                                  }

                                                  // Await the user acknowledgment from the AlertDialog
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(""),
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                "Account likes: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        18)),
                                                            SizedBox(width: 10),
                                                            Container(
                                                              width: 80,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadiusDirectional
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  user?['likeAmout']
                                                                          ?.toString() ??
                                                                      '4',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                "OK"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog when "OK" is pressed
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  // Reverse the animation after the dialog is acknowledged
                                                  if (_controllerHeart.status ==
                                                      AnimationStatus
                                                          .completed) {
                                                    _controllerHeart.reverse();
                                                  }
                                                },
                                                child: Lottie.asset(
                                                    "images/love.json",
                                                    controller:
                                                        _controllerHeart,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                  width: 190,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: const Color(0xFFA3A380),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "My Library",
                                    // style: TextStyle(
                                    //   color: Color.fromRGBO(239, 235, 205, 1),
                                    //   fontSize: 18,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    style: GoogleFonts.rubikMonoOne(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(239, 235, 205, 1),
                                          letterSpacing: .3,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))),
                            ),
                            const SizedBox(height: 30),
                            const Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 80),
                              child: SizedBox(
                                height: 290,
                                child: LibrarySlider(),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      color: Color(0xFFA3A380),
                    ),
                    const FriendsList(),
                    const UserFavoritePage(),
                    const UserLikePage(),
                  ],
                ),
              );
            } else {
              return Text("No data");
            }
          }),
    );
  }
}
