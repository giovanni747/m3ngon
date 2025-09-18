import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  Future<void> addPost(String message, String mangaRef) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to the user's document in Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      // Check if the user document exists
      if (userSnapshot.exists) {
        String userEmail = userSnapshot.get('email');
        String? profilePic = userSnapshot.get('profilePicture');
        String? username = userSnapshot.get('username');

        // Add the post to the 'Posts' collection
        posts.add({
          'user': username,
          'useremail': userEmail,
          'profilePic':
              profilePic, // Assuming 'profilePic' is the field name for the profile picture URL
          'PostMessage': message,
          'mangaREF': mangaRef,
          'TimeStamp': Timestamp.now(),
        });
      } else {
        throw Exception("User document does not exist");
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
