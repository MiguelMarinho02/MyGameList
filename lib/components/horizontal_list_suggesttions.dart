import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/pages/main_pages/game_page.dart';
import 'package:mal_clone/storage/storage.dart';

class MyHorizontalListSuggestion extends StatelessWidget {
  const MyHorizontalListSuggestion({super.key, required this.list, required this.listName});

  final List<QueryDocumentSnapshot> list;
  final String listName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listName,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GamePage(
                    uid: list[index].id,
                  ),
                )),
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: Column(
                children: [
                  //Image container
                  SizedBox(
                    height: 170,
                    width: 140,
                    child: FutureBuilder(
                      future: Storage().downloadGameImage(list[index].id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return Image.network(
                              snapshot.data ?? "",
                              fit: BoxFit.fill,
                            );
                          } else {
                            return const Text(
                              "No Image Found",
                              style: TextStyle(color: Colors.white),
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      list[index].get(GameFields.name),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }
}
