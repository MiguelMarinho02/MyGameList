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

  Future<QuerySnapshot> getCurrentUserHistory(String uid) async {
    final usersRef = db.collection("users");
    QuerySnapshot querySnapshot =
        await usersRef.doc(uid).collection("search_history").get();
    return querySnapshot;
  }

  Future addToSearchHistory(String item, String uid) async {
    final usersRef = db.collection("users");
    await usersRef.doc(uid).collection("search_history").add({"data": item});
  }

  Future deleteSearchHistory(String uid) async {
    final usersRef = db.collection("users");
    await usersRef.doc(uid).collection("search_history").get().then((querySnapshot) => {
      for(var doc in querySnapshot.docs){
        doc.reference.delete()
      }
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGame(String uid) async {
    final gamesRef = db.collection("games");
    final doc = await gamesRef.doc(uid).get();
    return doc;
  }

  Future<QuerySnapshot> getGamesWithLimit(int limit) async {
    final gamesRef = db.collection("games");
    QuerySnapshot querySnapshot = await gamesRef.limit(limit).get();
    return querySnapshot;
  }
}
