import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.uid});

  final String uid;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late DocumentSnapshot<Map<String, dynamic>> gameData;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getGameInfo();
  }

  Future getGameInfo() async {
    gameData = await FireStoreFunctions().getGame(widget.uid);
    setState(() {
      isLoading = false;
    });
  }

  String getScore() {
    var numOfRatings = gameData.get(GameFields.numOfRatings);
    var scoreTotal = gameData.get(GameFields.sumOfScores);

    double score = scoreTotal / numOfRatings;

    return score.toString();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(242, 13, 13, 14),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const MyBarText(
          text: "MGL",
          size: 35,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,      
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //image container
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.white,
                          )),
                          child: FutureBuilder(
                            future: Storage().downloadGameImage(gameData.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  return Image.network(
                                    snapshot.data ?? "",
                                    fit: BoxFit.cover,
                                    width: 270,
                                    height: 340,
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
                        //info like members and score
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 30,),
                              //Score
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Score",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.star, color: Colors.white,),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(getScore(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20,),
                              //members
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Members",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Text(
                                    gameData.get("members").toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(gameData.get("name"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 25)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
