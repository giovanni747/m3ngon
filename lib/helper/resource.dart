// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';

// class StoreData {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String> uploadImageToStorage(String childName, Uint8List file) async {
//     try {
//       Reference ref = _storage.ref().child(childName);
//       UploadTask uploadTask = ref.putData(file);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (error) {
//       print('Error uploading image to storage: $error');
//       throw 'Error uploading image to storage: $error';
//     }
//   }

//   Future<String> saveData({required Uint8List file}) async {
//     try {
//       String imageUrl = await uploadImageToStorage('ProfileImage', file);
//       String uid = _auth.currentUser!.uid; // Get the user's UID
//       DocumentReference userRef = _firestore.collection("users").doc(uid);

//       // Get the current user document
//       DocumentSnapshot userSnapshot = await userRef.get();

//       // Extract existing user data or initialize an empty map if null
//       Map<String, dynamic> userData =
//           userSnapshot.data() as Map<String, dynamic>? ?? {};

//       // Update the user document with the profile picture URL
//       await userRef.set({
//         ...userData,
//         'profilePic': imageUrl,
//       }, SetOptions(merge: true));

//       return 'Successful';
//     } catch (error) {
//       print('Error saving data: $error');
//       return 'Error saving data: $error';
//     }
//   }
// }
