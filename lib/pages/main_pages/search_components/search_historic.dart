import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:provider/provider.dart';

class MySearchHistoric extends StatefulWidget {
  const MySearchHistoric({super.key});

  @override
  State<MySearchHistoric> createState() => _MySearchHistoricState();
}

class _MySearchHistoricState extends State<MySearchHistoric> {
  Future<List<String>> getUserHistory(String uid) async {
    QuerySnapshot querySnapshot =
        await FireStoreFunctions().getCurrentUserHistory(uid);

    List<String> list = [];
    for (var doc in querySnapshot.docs) {
      list.add(doc.get("data"));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: SizedBox(
                  height: 30,
                  child: Text(
                    "Recent Searches",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () async{
                    await FireStoreFunctions().deleteSearchHistory(user!.uid);
                    setState(() {
                    });
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const Divider(),
          FutureBuilder(
            future: getUserHistory(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            snapshot.data![index],
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No history",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}
