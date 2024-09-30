import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/pages/main_pages/game_page.dart';
import 'package:mal_clone/storage/storage.dart';

class MySearchResults extends StatefulWidget {
  const MySearchResults({super.key, required this.results});

  final List<QueryDocumentSnapshot> results;

  @override
  State<MySearchResults> createState() => _MySearchResultsState();
}

class _MySearchResultsState extends State<MySearchResults> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: widget.results.isNotEmpty
            ? ListView.builder(
                itemCount: widget.results.length,
                itemBuilder: (context, index) => SizedBox(
                    height: 120,
                    child: GestureDetector(
                      onTap: () {
                        //send user to game page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GamePage(uid: widget.results[index].id),
                            ));
                      },
                      child: Container(
                        decoration: index != 0
                            ? const BoxDecoration(
                                border:
                                    Border(top: BorderSide(color: Colors.grey)))
                            : null,
                        child: Row(
                          children: [
                            SizedBox(
                              //image holder
                              width: 100,
                              child: FutureBuilder(
                                future: Storage().downloadGameImage(
                                    widget.results[index].id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.isNotEmpty) {
                                      return Image.network(snapshot.data ?? "");
                                    } else {
                                      return const Center(
                                        child: Text(
                                          "No data found",
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
                            const SizedBox(
                              width: 15,
                            ),
                            //game info
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.results[index].get("name"),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    Builder(
                                      //platforms and release date
                                      builder: (context) {
                                        String text =
                                            "${widget.results[index].get("launchDate")} (";
                                        for (var platform in widget
                                            .results[index]
                                            .get("platforms")) {
                                          text = "$text$platform, ";
                                        }
                                        text =
                                            "${text.substring(0, text.length - 2)})";
                                        return Text(
                                          text,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${widget.results[index].get("members")}",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                        const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
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
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    )),
              )
            : const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.white),
                ),
              ));
  }
}
