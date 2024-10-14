import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/components/horizontal_list_suggesttions.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/pages/main_pages/game_page.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:mal_clone/storage/storage.dart';

class MySearchSuggestions extends StatefulWidget {
  const MySearchSuggestions({super.key});

  @override
  State<MySearchSuggestions> createState() => _MySearchSuggestionsState();
}

class _MySearchSuggestionsState extends State<MySearchSuggestions> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> recentlyAddedGames = [];
  List<QueryDocumentSnapshot> bestScoredGames = [];
  List<QueryDocumentSnapshot> bestScoredGamesYear = [];

  @override
  void initState() {
    buildSuggestions();
    super.initState();
  }

  Future buildSuggestions() async {
    QuerySnapshot recentlyOrdered =
        await FireStoreFunctions().getGamesWithLimitByTimeStamp(10, true);

    for (var doc in recentlyOrdered.docs) {
      recentlyAddedGames.add(doc);
    }

    QuerySnapshot bestScoredOrdered =
        await FireStoreFunctions().getGamesWithLimitByScore(10, true);

    for (var doc in bestScoredOrdered.docs) {
      bestScoredGames.add(doc);
    }

    QuerySnapshot bestScoredOfTheYearOrdered =
        await FireStoreFunctions().getGamesWithLimitByScoreFromYear(10, true);

    for (var doc in bestScoredOfTheYearOrdered.docs) {
      bestScoredGamesYear.add(doc);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Flexible(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: MyHorizontalListSuggestion(list: recentlyAddedGames, listName: "Recently Added Games")
                    ),
                  ),
          
                  SizedBox(
                    height: 280,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: MyHorizontalListSuggestion(list: bestScoredGames, listName: "Best Scored Games")
                    ),
                  ),
          
                  SizedBox(
                    height: 280,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: MyHorizontalListSuggestion(list: bestScoredGamesYear, listName: "Best Scored Games of the Year")
                    ),
                  ),
                ],
              ),
            ),
        );
  }
}
