import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m3ngon/components/loadingPage.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserDetails>>(
      future:
          fetchUserDetails(), // Fetch user details based on following_users list
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: 100, height: 100, child: Center(child: LoaderScreen()));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data;
        if (users == null || users.isEmpty) {
          return Center(child: Text('No Friends'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return UserTile(user: user);
          },
        );
      },
    );
  }

  Future<List<UserDetails>> fetchUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return []; // Return an empty list if user is not logged in
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final userDoc = await userRef.get();

    final followingUsers =
        List<String>.from(userDoc.get('following_users') ?? []);

    final List<UserDetails> userDetailsList = [];

    for (final id in followingUsers) {
      try {
        final userDetails = await getUserDetailsFromFirestore(id: id);
        userDetailsList.add(userDetails);
      } catch (e) {
        print('Error fetching user details for ID $id: $e');
      }
    }

    return userDetailsList;
  }

  Future<UserDetails> getUserDetailsFromFirestore({required String id}) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final username = doc.get('username');
    final image = doc.get('profilePicture');
    // You can fetch other user details here
    return UserDetails(id: id, username: username, image: image);
  }
}

class UserDetails {
  final String id;
  final String username;
  final String image;

  UserDetails({required this.id, required this.username, required this.image});
}

class UserTile extends StatelessWidget {
  final UserDetails user;

  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to user profile or perform any action
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(60),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '@' + user.username,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
