import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/model/team_model.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';
import 'package:flutter_test1/tabs/attendances/attendance_tab.dart';

import 'package:flutter_test1/tabs/matches/matches_tab.dart';
import 'package:flutter_test1/tabs/playerslist.dart';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter_test1/tabs/profile/profile_data.dart';
import 'package:provider/provider.dart';

class ProfileTabView extends StatefulWidget {
  final teamsnapshot;
  final playersnapshot;
  final Stream playerStream;
  final Stream teamStream;
  ProfileTabView(
    this.teamsnapshot,
    this.teamStream,
    this.playersnapshot,
    this.playerStream,
  );

  @override
  _ProfileTabViewState createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  bool hasTeam = false;
  String teamname = "";
  String teamid = "";
  TextEditingController teamcodeController = TextEditingController();
  Map<String, dynamic>? user;
  Map<String, dynamic>? team;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _joinprovider(Player playerinstance, Team teaminstance,
      Map<String, dynamic> team) async {
    context.read<PlayerProvider>().selectUser(playerinstance);
    context.read<TeamProvider>().selectUser(teaminstance);
    context.read<PlayerProvider>().addTeamname(team["name"], team["id"]);
    context.read<TeamProvider>().addPlayer(user?["id"]);
  }

  Future<void> quitprovider() async {
    Player playerinstance = Player.fromJson(user!);
    Team teaminstance = Team.fromJson(team!);
    //Remove player in team
    context.read<TeamProvider>().selectUser(teaminstance);
    context.read<TeamProvider>().removePlayer(user!['id']);
    //remove the matchlogs and attendance logs
    context.read<PlayerProvider>().selectUser(playerinstance);
    context.read<PlayerProvider>().removelogs();
    context.read<PlayerProvider>().resetElo();
    context.read<PlayerProvider>().removeTeam();
  }

  Future<void> quitteam() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text(
                "By clicking 'OK', you will permanently remove yourself from the team. This action will reset your Elo rating and delete all attendance and match history associated with this team. Are you sure you want to proceed?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  setState(() {
                    hasTeam = false;
                    teamname = "";
                  });
                  for (int i = 0;
                      i < widget.teamsnapshot.data?.docs.length;
                      i++) {
                    team = widget.teamsnapshot.data?.docs[i].data()
                        as Map<String, dynamic>;

                    if (team?['id'] == user?['teamid']) {
                      break;
                    } else {
                      team = null;
                    }
                  }

                  await quitprovider();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          );
        });
  }

  Future<void> jointeam() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Join a Team"),
            content: TextField(
              controller: teamcodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Team Code",
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // Team? playeruser;
                  for (int i = 0;
                      i < widget.teamsnapshot.data?.docs.length;
                      i++) {
                    team = widget.teamsnapshot.data?.docs[i].data()
                        as Map<String, dynamic>;

                    if (team?['code'] == teamcodeController.text) {
                      break;
                    } else {
                      team = null;
                    }
                  }

                  if (team != null) {
                    setState(() {
                      hasTeam = true;
                      teamname = team!["name"];
                      teamid = team!["id"];
                    });
                    Player playerinstance = Player.fromJson(user!);
                    Team teaminstance = Team.fromJson(team!);

                    await _joinprovider(playerinstance, teaminstance, team!);

                    print(hasTeam);
                    print(teamname);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Successfully joined $teamname!')));
                    Navigator.of(context).pop();
                    // Remove dialog after adding
                  } else {
                    //ERROR MESSAGE
                    Navigator.of(context).pop();
                    alert(context, title: Text("Team does not exist!"));
                    print("No Team Found!");
                  }
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text("Join"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        body: Builder(builder: (context) {
          // Team? playeruser;
          int? userType;
          for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
            user = widget.teamsnapshot.data?.docs[i].data()
                as Map<String, dynamic>;

            if (user?['id'] ==
                context.read<AuthenticationProvider>().getUser()) {
              userType = 0;
              break;
            } else {
              user = null;
            }
          }
          if (user == null) {
            for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
              // user = Player.fromJson(widget.playersnapshot.data?.docs[i].data()
              //     as Map<String, dynamic>) as Map<String, dynamic>?;
              user = widget.playersnapshot.data?.docs[i].data()
                  as Map<String, dynamic>;
              if (user?['id'] ==
                  context.read<AuthenticationProvider>().getUser()) {
                print(user);
                userType = 1;
                break;
              } else {
                user = null;
              }
            }
          }

          String displayname = user?["displayname"] ?? user?["name"];
          // String contactnumber = user?["contactnumber"];
          // String email = user?["email"];
          // String beltcolor = user?["beltcolor"];
          // String height = user?["height"];
          // String weight = user?["weight"];
          // String sex = user?["sex"];
          // String birthdate = user?["birthdate"];
          // String trainingdateStart = user?["trainingdateStart"];
          teamname = user?["teamname"] ?? "";

          if (teamname == "") {
            hasTeam = false;
          } else {
            hasTeam = true;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  "assets/img/profilepic.png",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayname,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      teamname,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (userType == 0)
                                SizedBox(
                                  width: 150,
                                  height: 25,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Center(
                                                  child: Text(user?["code"])),
                                            );
                                          });
                                    },
                                    child:
                                        const Text("Team Code"), // Button text
                                  ),
                                )
                              else
                                SizedBox(
                                  width: 120,
                                  height: 25,
                                  child: ElevatedButton(
                                    onPressed: (!hasTeam && userType == 1)
                                        ? jointeam
                                        : quitteam,
                                    child: (!hasTeam && userType == 1)
                                        ? const Text("Join")
                                        : const Text("Quit"), // Button text
                                  ),
                                )
                              // else if (hasTeam && userType == 1)
                              //   SizedBox(
                              //     width: 120,
                              //     height: 25,
                              //     child: ElevatedButton(
                              //       onPressed: () async {
                              //         setState(() {
                              //           hasTeam = false;
                              //           teamname = "";
                              //         });
                              //         for (int i = 0;
                              //             i <
                              //                 widget.teamsnapshot.data?.docs
                              //                     .length;
                              //             i++) {
                              //           team = widget.teamsnapshot.data?.docs[i]
                              //               .data() as Map<String, dynamic>;

                              //           if (team?['id'] == user?['teamid']) {
                              //             break;
                              //           } else {
                              //             team = null;
                              //           }
                              //         }
                              //         print(hasTeam);
                              //         await quitprovider();

                              //         print(hasTeam);
                              //       },
                              //       child: const Text("Quit"), // Button text
                              //     ),
                              //   )
                            ],
                          ),
                        ]),
                  ),
                  Container(
                    height: 56.0,
                    child: TabBar(
                      tabs: [
                        if (userType == 0)
                          const Tab(
                              child: Text(
                            "Players",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        if (userType == 1)
                          const Tab(
                              child: Text(
                            "Personal Data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        const Tab(
                            child: Text(
                          "Match History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                        const Tab(
                            child: Text(
                          "Attendance History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      if (userType == 1) ProfileData(user, 0),
                      if (userType == 0)
                        PlayersViewPage(
                            user,
                            widget.playersnapshot,
                            widget.teamsnapshot,
                            widget.playerStream,
                            widget.teamStream),
                      MatchesViewPage(user),
                      AttendanceTab(user),
                    ]),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
