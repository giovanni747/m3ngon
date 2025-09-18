import 'package:cloud_firestore/cloud_firestore.dart';

// put all functions in here
class FirestoreService {
  // get collection of notes
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');

  // Create: add a new document
  // Future<void> addinfo(String poke) {
  //   return user.add({
  //     'name': poke,
  //     'timestamp': Timestamp.now(),
  //   });
  // }

  // Read: get documents from database
  Stream<QuerySnapshot> getuserStream() {
    final userStream = user.orderBy('timestamp', descending: true).snapshots();
    return userStream;
  }

  // Update: update
  // Future<void> updatePoke(String docID, bool newBool) {
  //   return user.doc(docID).update({'used': newBool});
  // }

  // Delete
  Future<void> deletePoke(String docID) {
    return user.doc(docID).delete();
  }
}
