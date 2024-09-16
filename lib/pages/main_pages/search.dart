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
  int selectedState = 0;

  ///0 for suggestions page, 1 for historic page, 2 for results
  TextEditingController searchBar = TextEditingController();
  
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
                    selectedState = 1; //change screen to show suggestions
                  });
                },
                onEditingComplete: () {
                  FireStoreFunctions()
                      .addToSearchHistory(searchBar.text.trim(), user!.uid);
                  //add logic to handle search
                  setState(() {
                    selectedState = 2; //change screen to show results
                  });
                },
              ),
            ),
          ),
        ),
        Container(
          child: <Widget>[
            MySearchSuggestions(),
            MySearchHistoric(),
            MySearchResults()
          ][selectedState],
        )
      ],
    );
  }
}
