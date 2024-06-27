import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/tabs/leaderboards_tab.dart';
import 'package:flutter_test1/tabs/features/ranker_tab.dart';
import 'package:flutter_test1/tabs/matches/matchdetails.dart';
import 'package:provider/provider.dart';

class HomeTabView extends StatefulWidget {
  final teamsnapshot;
  final playersnapshot;
  final Stream playerStream;
  final Stream teamStream;
  const HomeTabView(this.teamsnapshot, this.teamStream, this.playersnapshot,
      this.playerStream,
      {super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(body: Builder(builder: (context) {
      Map<String, dynamic>? user;
      int? userType;
      for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
        user = widget.teamsnapshot.data?.docs[i].data() as Map<String, dynamic>;
        if (user['id'] == context.read<AuthenticationProvider>().getUser()) {
          userType = 0;
          break;
        } else {
          user = null;
        }
      }
      if (user == null) {
        for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
          user = widget.playersnapshot.data?.docs[i].data()
              as Map<String, dynamic>;
          if (user['id'] == context.read<AuthenticationProvider>().getUser()) {
            print(user);
            userType = 1;
            break;
          } else {
            user = null;
          }
        }
      }
// get the highest ranked
      Map<String, dynamic>? highest;
      if (userType == 0) {
        for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
          Map<String, dynamic> temp = widget.playersnapshot.data?.docs[i].data()
              as Map<String, dynamic>;
          if (temp["teamid"] == user?["id"]) {
            highest ??= temp;
            if (temp['elo'] > highest['elo']) {
              highest = temp;
            }
          }
        }
      } else {
        for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
          Map<String, dynamic> temp = widget.playersnapshot.data?.docs[i].data()
              as Map<String, dynamic>;
          if ((temp["teamid"] == user?["teamid"]) && (temp["teamid"] != null)) {
            highest ??= temp;
            if (temp['elo'] > highest['elo']) {
              highest = temp;
            }
          }
        }
      }
      if (userType == 0) {
        return Scaffold(
          // backgroundColor: TColor.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back,",
                      style: TextStyle(color: TColor.gray, fontSize: 16)),
                  Text("Coach!",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Container(
                    height: media.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius:
                            BorderRadius.circular(media.width * 0.075)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    child: Image.asset(
                                      "assets/img/crown.png",
                                      width: media.width * .15,
                                      height: media.width * .15,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text("Current Leader ",
                                      style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Center(
                                  child: highest?['displayname'] != null
                                      ? Text("${highest?['displayname']}",
                                          style: TextStyle(
                                              color:
                                                  TColor.white.withOpacity(0.7),
                                              fontSize: 16))
                                      : Text("N/A",
                                          style: TextStyle(
                                              color:
                                                  TColor.white.withOpacity(0.7),
                                              fontSize: 16)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (user?["players"].length == 0) {
                                        alert(context,
                                            title: const Text(
                                                "You have no members yet!"));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LeaderboardPage(
                                                widget.playersnapshot,
                                                widget.teamsnapshot);
                                          },
                                        );
                                      }
                                    },
                                    child: const Text(
                                        "Show Leaderboard"), // Button text
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (user?["players"].length < 2) {
                                        alert(context,
                                            title: const Text(
                                                "You don't have enough members!"));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                MatchDetailsAlertDialog(user,
                                                    widget.playersnapshot));
                                      }
                                    },
                                    child: const Text(
                                        "Create Match"), // Button text
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Warning"),
                                              content: const Text(
                                                  "By clicking 'OK', you will permanently reset the elo rating of all your members back to 1200. Are you sure you want to proceed?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    for (int i = 0;
                                                        i <
                                                            user?["players"]
                                                                .length;
                                                        i++) {
                                                      for (int j = 0;
                                                          j <
                                                              widget
                                                                  .playersnapshot
                                                                  .data
                                                                  ?.docs
                                                                  .length;
                                                          j++) {
                                                        Map<String, dynamic>
                                                            player = widget
                                                                    .playersnapshot
                                                                    .data
                                                                    ?.docs[j]
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        if (player['id'] ==
                                                            user?["players"]
                                                                [i]) {
                                                          context
                                                              .read<
                                                                  PlayerProvider>()
                                                              .selectUser(Player
                                                                  .fromJson(
                                                                      player));
                                                          context
                                                              .read<
                                                                  PlayerProvider>()
                                                              .resetElo();
                                                        }
                                                      }
                                                    }
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                'Elo reset success!')));
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancel"),
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child:
                                        const Text("Reset Elo"), // Button text
                                  ),
                                )
                                // RankerViewPage(user, widget.playersnapshot),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // RankerViewPage(user, widget.playersnapshot),
                ],
              ),
            ),
          ),
        );
      } else if (userType == 1) {
        return Scaffold(
          // backgroundColor: TColor.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back,",
                      style: TextStyle(color: TColor.gray, fontSize: 16)),
                  Text("${user?["displayname"]}",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Container(
                    height: media.width * 0.5,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius:
                            BorderRadius.circular(media.width * 0.075)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    child: Image.asset(
                                      "assets/img/crown.png",
                                      width: media.width * .15,
                                      height: media.width * .15,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text("Current Leader ",
                                      style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Center(
                                  child: highest?['displayname'] != null
                                      ? Text("${highest?['displayname']}",
                                          style: TextStyle(
                                              color:
                                                  TColor.white.withOpacity(0.7),
                                              fontSize: 16))
                                      : Text("N/A",
                                          style: TextStyle(
                                              color:
                                                  TColor.white.withOpacity(0.7),
                                              fontSize: 16)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (user?["teamid"] == null) {
                                        alert(context,
                                            title: const Text(
                                                "You haven't joined a team yet!"));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LeaderboardPage(
                                                widget.playersnapshot,
                                                widget.teamsnapshot);
                                          },
                                        );
                                      }
                                    },
                                    child: const Text(
                                        "Show Leaderboard"), // Button text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Container();
    }));
  }
}
