import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/pages/main_pages/game_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';

class MyList extends StatefulWidget {
  const MyList({super.key, this.userId});

  final String? userId;

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  int currentPageIndex = 0;
  bool isLoading = true;
  late List<QueryDocumentSnapshot> all = [];
  late List<QueryDocumentSnapshot> completedList = [];
  late List<QueryDocumentSnapshot> toPlayList = [];
  late List<QueryDocumentSnapshot> droppedList = [];
  late List<QueryDocumentSnapshot> onHoldList = [];
  late List<List<QueryDocumentSnapshot>> lists = [
    all,
    completedList,
    onHoldList,
    droppedList,
    toPlayList
  ];

  List<String> status = [
    "All",
    "Completed",
    "On Hold",
    "Dropped",
    "Plan to Play"
  ];

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    QuerySnapshot querySnapshot =
        await FireStoreFunctions().getCurrentUserGameList(widget.userId ?? "");

    for (var doc in querySnapshot.docs) {
      if (doc.get("status") == "completed") {
        completedList.add(doc);
      }
      if (doc.get("status") == "onHold") {
        onHoldList.add(doc);
      }
      if (doc.get("status") == "dropped") {
        droppedList.add(doc);
      }
      if (doc.get("status") == "toPlay") {
        toPlayList.add(doc);
      }
      all.add(doc);
    }

    lists = [all, completedList, onHoldList, droppedList, toPlayList];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Column(
      children: [
        // Header for Status Tabs
        Container(
          color: Theme.of(context).colorScheme.primary,
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              scrollDirection: Axis.horizontal,
              itemCount: status.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: currentPageIndex == index
                        ? const Border(
                            bottom: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.white,
                              width: 5,
                            ),
                          )
                        : const Border(),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    status[index],
                    style: TextStyle(
                      color: index == currentPageIndex
                          ? Colors.white
                          : Colors.blueGrey,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Entries Count
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                !isLoading ? "${lists[currentPageIndex].length} Entries" : "",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        // List of Items
        Expanded(
          child: ListView.builder(
            itemCount: lists[currentPageIndex].length,
            itemBuilder: (context, index) => SizedBox(
              height: 120,
              child: GestureDetector(
                onTap: () {
                  // Handle navigation to the game page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GamePage(uid: lists[currentPageIndex][index].id),
                      ));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey))),
                  child: Row(
                    children: [
                      // Placeholder for Game Image
                      SizedBox(
                        width: 100,
                        child: FutureBuilder(
                          future: Storage().downloadGameImage(
                              lists[currentPageIndex][index].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return Image.network(snapshot.data ?? "");
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
                      const SizedBox(width: 15),
                      // Game Info and Actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Game Name
                            Text(
                              lists[currentPageIndex][index].get("name"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 25),
                            ),
                            // Launch Date
                            Text(
                              lists[currentPageIndex][index].get("launchDate"),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                            ),
                            const SizedBox(height: 26),
                            // Rating and Edit Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating and Star
                                Row(
                                  children: [
                                    Text(
                                      lists[currentPageIndex][index]
                                              .get("rating") ??
                                          "Not Rated",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    if (lists[currentPageIndex][index]
                                            .get("rating") !=
                                        null)
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                  ],
                                ),
                                //edit button
                                GestureDetector(
                                  onTap: () {
                                    // Handle edit action
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
