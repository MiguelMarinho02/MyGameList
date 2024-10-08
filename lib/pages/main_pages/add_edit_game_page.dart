import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mal_clone/enumerations.dart';
import 'package:mal_clone/storage/firestore.dart';

class AddEditGamePage extends StatefulWidget {
  const AddEditGamePage(
      {super.key, required this.gameID, required this.userID});

  final String gameID;
  final String userID;

  @override
  State<AddEditGamePage> createState() => _AddEditGamePageState();
}

class _AddEditGamePageState extends State<AddEditGamePage> {
  late DocumentSnapshot<Map<String, dynamic>> userGameDetails;
  late DocumentSnapshot<Map<String, dynamic>> gameData;

  List<dynamic> platforms = ["-"];
  List<String> status = [
    GameListStatus.toPlay, //0
    GameListStatus.completed, //1
    GameListStatus.dropped, //2
    GameListStatus.onHold, //3
    GameListStatus.playing, //4
  ];

  List<String> statusNames = [
    "Plan to Play",
    "Completed",
    "Dropped",
    "On Hold",
    "Playing"
  ];

  List<String> ratings = [
    "-",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];

  //if both stay at -1, it means that both were not found in the user list
  int platformIndex = 0;
  int statusIndex = 0;
  int ratingIndex = 0;

  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    userGameDetails = await FireStoreFunctions()
        .getGameFromUserGameList(widget.userID, widget.gameID);

    gameData = await FireStoreFunctions().getGame(widget.gameID);

    platforms.addAll(gameData.get(GameFields.platforms));

    if (userGameDetails.exists) {
      switch (userGameDetails.get(GameListFields.status)) {
        case GameListStatus.completed:
          statusIndex = 1;
          break;
        case GameListStatus.dropped:
          statusIndex = 2;
          break;
        case GameListStatus.onHold:
          statusIndex = 3;
          break;
        case GameListStatus.playing:
          statusIndex = 4;
          break;
        default:
          statusIndex = 0;
          break;
      }

      //confusing way to discover wich order the list of platforms in firebase is (bruh)
      for (int i = 0; i < platforms.length; i++) {
        if (platforms[i] == userGameDetails.get(GameListFields.platform)) {
          platformIndex = i;
          break;
        }
      }

      if (userGameDetails.get(GameListFields.rating) != "-") {
        ratingIndex = int.parse(userGameDetails.get(GameListFields.rating)) + 1;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future setData() async {
    if (userGameDetails.exists) {
      var data = {
        GameListFields.platform: platforms[platformIndex],
        GameListFields.rating: ratings[ratingIndex],
        GameListFields.status: status[statusIndex],
      };
      await FireStoreFunctions()
          .updateGameToUserGameList(widget.userID, widget.gameID, data);
    }else{
      var data = {
        GameListFields.name : gameData.get(GameFields.name),
        GameListFields.dateAdded : "",
        GameListFields.dateFinished : "",
        GameListFields.launchDate : gameData.get(GameFields.launchDate),
        GameListFields.platform: platforms[platformIndex],
        GameListFields.rating: ratings[ratingIndex],
        GameListFields.status: status[statusIndex],
      };

      if(status[statusIndex] == GameListStatus.playing){
        data.update(GameListFields.dateAdded, (value) => DateTime(DateTime.now().day, DateTime.now().month, DateTime.now().year).toString());
      }

      await FireStoreFunctions()
          .addGameToUserGameList(widget.userID, widget.gameID, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(240, 26, 26, 26),
        body: Builder(
          builder: (context) => isLoading
              ? const CircularProgressIndicator()
              : Container(
                  margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //quit button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 35,
                              ),
                            ),

                            //save button
                            GestureDetector(
                              onTap: () async {
                                await setData();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 10, 6, 231),
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      //all logic to add fields
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.82,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Name of the game
                            Text(
                              gameData.get("name"),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //status select
                            const Text(
                              "Status",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: status.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => setState(() {
                                    statusIndex = index;
                                  }),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: index == statusIndex
                                            ? const Color.fromARGB(
                                                255, 10, 6, 231)
                                            : null,
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      statusNames[index],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //platform select
                            const Text(
                              "Platform",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: platforms.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => setState(() {
                                    platformIndex = index;
                                  }),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: index == platformIndex
                                            ? const Color.fromARGB(
                                                255, 10, 6, 231)
                                            : null,
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      platforms[index],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //score select
                            const Text(
                              "Rating Score",
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ratings.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => setState(() {
                                    ratingIndex = index;
                                  }),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: index == ratingIndex
                                            ? const Color.fromARGB(
                                                255, 10, 6, 231)
                                            : null,
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                      ratings[index],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      //remove from list button
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: GestureDetector(
                          onTap: () async {
                            await FireStoreFunctions()
                                .deleteGameFromUserGameList(
                                    widget.userID, widget.gameID);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 35,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Remove from list",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }
}
