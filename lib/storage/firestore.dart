import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreFunctions {
  final db = FirebaseFirestore.instance;

  Future<bool> checkUsernameUniqueness(String username) async {
    final usersRef = db.collection("users");
    QuerySnapshot querySnapshot =
        await usersRef.where("username", isEqualTo: username).get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<QuerySnapshot> getCurrentUserGameList(String uid) async {
    final usersRef = db.collection("users");
    QuerySnapshot querySnapshot =
        await usersRef.doc(uid).collection("list").get();
    return querySnapshot;
  }
}
