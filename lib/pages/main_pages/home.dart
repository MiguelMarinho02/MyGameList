import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/pages/main_pages/game_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key, required this.userId});

  final String userId;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isLoading = true;
  List<Map<String, QueryDocumentSnapshot<Object?>>> list = [];
  late QuerySnapshot userGameList;

  @override
  void initState() {
    buildNewsList();
    super.initState();
  }

  Future buildNewsList() async {
    String userId = widget.userId;
    if (userId == "null") {
      userId = FirebaseAuth.instance.currentUser!.uid;
    }

    userGameList = await FireStoreFunctions().getCurrentUserGameList(userId);

    for (var doc in userGameList.docs) {
      QuerySnapshot gameDiscussions = await FireStoreFunctions()
          .getGamesDiscussionsWithDate(
              doc.id, doc.get(GameListFields.dateAddedToList));

      for (QueryDocumentSnapshot<Object?> doc2 in gameDiscussions.docs) {
        list.add({doc.id: doc2});
      }
    }

    list.sort((b, a) => a.values.first
        .get("creationDate")
        .compareTo(b.values.first.get("creationDate")));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return isLoading
        ? const CircularProgressIndicator()
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => SizedBox(
              height: 150,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GamePage(uid: list[index].keys.first),
                            )),
                        child: FutureBuilder(
                          future: Storage()
                              .downloadGameImage(list[index].keys.first),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return Image.network(
                                  snapshot.data ?? "",
                                  height: 150,
                                  fit: BoxFit.fill,
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    "No Data Found",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    //add gesture detecture to send tto disccussion
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userGameList.docs
                              .where((a) => a.id == list[index].keys.first)
                              .first
                              .get(GameListFields.name),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),

                        //add disccusion text here
                        Text(
                          list[index].values.first.get("description"),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
