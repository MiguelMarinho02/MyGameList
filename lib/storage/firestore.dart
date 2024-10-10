import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mal_clone/enumerations.dart';

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

  Future<DocumentSnapshot<Map<String, dynamic>>> getGameFromUserGameList(
      String uid, String gameid) async {
    final usersRef = db.collection("users");
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await usersRef.doc(uid).collection("list").doc(gameid).get();
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
    await usersRef
        .doc(uid)
        .collection("search_history")
        .get()
        .then((querySnapshot) => {
              for (var doc in querySnapshot.docs) {doc.reference.delete()}
            });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGame(String uid) async {
    final gamesRef = db.collection("games");
    final doc = await gamesRef.doc(uid).get();
    return doc;
  }

  Future<QuerySnapshot> getGames() async {
    final gamesRef = db.collection("games");
    QuerySnapshot querySnapshot = await gamesRef.get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getGamesWithLimit(int limit) async {
    final gamesRef = db.collection("games");
    QuerySnapshot querySnapshot = await gamesRef.limit(limit).get();
    return querySnapshot;
  }

  Future addRemoveGameMembers(String gameid, bool remove) async {
    final gamesRef = db.collection("games");
    DocumentSnapshot<Map<String, dynamic>> game = await getGame(gameid);
    int numOfMembers = game.get(GameFields.members);

    if (remove) {
      numOfMembers--;
    } else {
      numOfMembers++;
    }

    await gamesRef.doc(gameid).update({
      GameFields.members: numOfMembers,
    });
  }

  Future addRemoveGameScore(String gameid, int score, bool remove) async {
    final gamesRef = db.collection("games");
    DocumentSnapshot<Map<String, dynamic>> game = await getGame(gameid);
    int numOfScores = game.get(GameFields.numOfRatings);
    int sumOfScores = game.get(GameFields.sumOfScores);

    if (remove) {
      numOfScores--;
      sumOfScores -= score;
    } else {
      numOfScores++;
      sumOfScores += score;
    }

    await gamesRef.doc(gameid).update({
      GameFields.numOfRatings: numOfScores,
      GameFields.sumOfScores: sumOfScores
    });
  }

  Future updateGameScore(String gameid, int score, int oldScore) async {
    final gamesRef = db.collection("games");
    DocumentSnapshot<Map<String, dynamic>> game = await getGame(gameid);

    await gamesRef.doc(gameid).update({
      GameFields.sumOfScores:
          game.get(GameFields.sumOfScores) + (score - oldScore)
    });
  }

  //these 3 need more logic to handle user count and score
  Future addGameToUserGameList(
      String uid, String gameid, Map<String, dynamic> data) async {
    final usersRef = db.collection("users");
    if (data[GameListFields.rating] != "-") {
      await addRemoveGameScore(
          gameid, int.parse(data[GameListFields.rating]), false);
    }
    await addRemoveGameMembers(gameid, false);
    await usersRef.doc(uid).collection("list").doc(gameid).set(data);
  }

  Future updateGameToUserGameList(
    String uid,
    String gameid,
    Map<String, dynamic> data,
    Map<String, dynamic> oldData,
  ) async {
    final usersRef = db.collection("users");

    if (data[GameListFields.rating] != oldData[GameListFields.rating]) {
      if (data[GameListFields.rating] == "-") {
        //if removed rating
        await addRemoveGameScore(
            gameid, int.parse(oldData[GameListFields.rating]), true);
      } else if (oldData[GameListFields.rating] == "-") {
        //if added a rating
        await addRemoveGameScore(
            gameid, int.parse(data[GameListFields.rating]), false);
      } else {
        //in case a rating changed from a number to another number
        await updateGameScore(gameid, int.parse(data[GameListFields.rating]),
            int.parse(oldData[GameListFields.rating]));
      }
    }

    await usersRef.doc(uid).collection("list").doc(gameid).update(data);
  }

  Future deleteGameFromUserGameList(
    String uid,
    String gameid,
    Map<String, dynamic> data,
  ) async {
    final usersRef = db.collection("users");
    if (data[GameListFields.rating] != "-") {
      await addRemoveGameScore(
          gameid, int.parse(data[GameListFields.rating]), true);
    }
    await addRemoveGameMembers(gameid, true);
    await usersRef.doc(uid).collection("list").doc(gameid).delete();
  }
}
