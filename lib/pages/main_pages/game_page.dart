import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_clone/components/app_text_title.dart';
import 'package:mal_clone/components/game_page_text_details.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/pages/main_pages/add_edit_game_page.dart';
import 'package:mal_clone/providers/user_provider.dart';
import 'package:mal_clone/storage/firestore.dart';
import 'package:mal_clone/storage/storage.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.uid});

  final String uid;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late DocumentSnapshot<Map<String, dynamic>> gameData;
  late YoutubePlayerController _controller;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getGameInfo();
  }

  @override
  void deactivate() {
    _controller.pauseVideo();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future getGameInfo() async {
    gameData = await FireStoreFunctions().getGame(widget.uid);
    setState(() {
      isLoading = false;
      _controller = YoutubePlayerController.fromVideoId(
          videoId: YoutubePlayerController.convertUrlToId(
                  gameData.get(GameFields.trailerURL)) ??
              "",
          autoPlay: false,
          params: const YoutubePlayerParams(
            mute: false,
            showControls: true,
            enableJavaScript: false,
          ));
    });
  }

  String getScore() {
    var numOfRatings = gameData.get(GameFields.numOfRatings);
    var scoreTotal = gameData.get(GameFields.sumOfScores);

    if (numOfRatings == 0) {
      return "N/A";
    }

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
                  //Image and information like score and members
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //image container
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.67, // Fixed width
                          child: Container(
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
                        ),
                        //info like members and score
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
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
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
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
                              const SizedBox(
                                height: 20,
                              ),
                              //members
                              MyFieldGamePage(
                                  fieldName: "Members",
                                  fieldContent:
                                      gameData.get("members").toString(),
                                  crossAxisAlignment: CrossAxisAlignment.end),
                              //add more stuff eventually
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Game name
                  Text(gameData.get("name"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                          color: Colors.white, fontSize: 25)),
                  //platforms
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: Text(gameData.get(GameFields.platforms).toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                            color: Colors.grey, fontSize: 15)),
                  ),
                  //tags
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        runSpacing: 5,
                        children: List.generate(
                            gameData.get(GameFields.tags).length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    //add rouute to said tag page
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Text(
                                      gameData.get(GameFields.tags)[index],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 1, 70, 218)),
                                    ),
                                  ),
                                )),
                      )),
                  //Description
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        gameData.get(GameFields.description),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )),

                  //Youtube trailer
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: YoutubePlayer(
                        controller: _controller,
                        aspectRatio: 16 / 9,
                      )),
                  const Divider(),

                  //Details
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //studio, release date,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyFieldGamePage(
                              fieldName: "Studio",
                              fieldContent: gameData.get(GameFields.studio),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              fontSizeContent: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyFieldGamePage(
                              fieldName: "Launch Date",
                              fieldContent: FireStoreFunctions().convertTimeStampToDate(gameData.get(GameFields.launchDate)),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              fontSizeContent: 20,
                            ),
                          ],
                        ),
                        //publisher, ageRating
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyFieldGamePage(
                              fieldName: "Publisher",
                              fieldContent: gameData.get(GameFields.publisher),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              fontSizeContent: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MyFieldGamePage(
                              fieldName: "Rating",
                              fieldContent: gameData.get(GameFields.ageRating),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              fontSizeContent: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //add more?? maybe actors? or details regarding the review like number of people who have given a score

                  //last free space
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditGamePage(
                  gameID: gameData.id,
                  userID: user!.uid,
                ),
              ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
