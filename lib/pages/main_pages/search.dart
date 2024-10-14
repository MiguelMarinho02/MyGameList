import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/pages/main_pages/search_components/search_historic.dart';
import 'package:mal_clone/pages/main_pages/search_components/search_results.dart';
import 'package:mal_clone/pages/main_pages/search_components/search_suggestions.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:provider/provider.dart';

class MySearch extends StatefulWidget {
  const MySearch({super.key});

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  int selectedState =
      0; //0 for suggestions page, 1 for historic page, 2 for results
  List<QueryDocumentSnapshot> results = [];

  TextEditingController searchBar = TextEditingController();

  Future getSearchResults() async {
    //this function is using a bad method to filter the results. In a bigger bd, another method should be used
    QuerySnapshot querySnapshot = await FireStoreFunctions().getGames();

    //filter search
    for (var doc in querySnapshot.docs) {
      if (doc
          .get("name")
          .toString()
          .toLowerCase()
          .contains(searchBar.text.trim().toLowerCase())) {
        results.add(doc);
      }
    }
  }

  void performSearch(String uid, bool repeatedSearch) async {
    results = [];

    if(!repeatedSearch){
      await FireStoreFunctions().addToSearchHistory(searchBar.text.trim(), uid);
    }

    //logic to handle search
    await getSearchResults();
    setState(() {
      selectedState = 2; //change screen to show results
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Column(
      children: [
        //Sized box to fit the search bar
        Container(
          color: Theme.of(context).primaryColor,
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: TextField(
                controller: searchBar,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(242, 13, 13, 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  filled: true,
                ),
                style: const TextStyle(color: Colors.white),
                onTap: () {
                  setState(() {
                    selectedState = 1; //change screen to show historic
                  });
                },
                onEditingComplete: () async {
                  if (searchBar.text.length <= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(8),
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.red,
                        ),
                        child: const Text(
                          "Text must have more than 3 chars",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ));
                    return;
                  }
                  performSearch(user!.uid, false);
                },
              ),
            ),
          ),
        ),
        Container(
          child: <Widget>[
            const MySearchSuggestions(),
            MySearchHistoric(
              textEditingController: searchBar,
              performSearch: performSearch,
            ),
            MySearchResults(
              results: results,
            )
          ][selectedState],
        )
      ],
    );
  }
}
