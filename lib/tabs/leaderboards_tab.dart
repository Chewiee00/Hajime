import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/tabs/profile/playerlist_profile.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  final playersnapshot;
  final teamsnapshot;
  const LeaderboardPage(this.playersnapshot, this.teamsnapshot, {super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? team;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<Map> teamlist = [];
    return Builder(builder: (context) {
      int? userType;
      for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
        user = widget.teamsnapshot.data?.docs[i].data() as Map<String, dynamic>;

        if (user?['id'] == context.read<AuthenticationProvider>().getUser()) {
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
          if (user?['id'] == context.read<AuthenticationProvider>().getUser()) {
            print(user);
            userType = 1;
            break;
          } else {
            user = null;
          }
        }
      }
      if (userType == 1) {
        String teamid = user?["teamid"];
        Map<String, dynamic>? player;
        teamlist = [];
        for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
          player = widget.playersnapshot.data?.docs[i].data()
              as Map<String, dynamic>;
          if (player['teamid'] == teamid) {
            teamlist.add(player);
            print(player);
          }
        }
      }

      if (userType == 0) {
        Map<String, dynamic>? player;
        teamlist = [];
        for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
          player = widget.playersnapshot.data?.docs[i].data()
              as Map<String, dynamic>;
          if (player['teamid'] == user?["id"]) {
            teamlist.add(player);
            print(player);
          }
        }
      }

      // print(teamlist);

      if (teamlist.isNotEmpty) {
        teamlist.sort((b, a) => a['elo'].compareTo(b['elo']));

        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text("Leaderboard",
                  style: TextStyle(fontWeight: FontWeight.w700))),
          body: ListView.builder(
            itemCount: teamlist.length,
            itemBuilder: (context, index) {
              int rank = index + 1;
              String playername = teamlist[index]['displayname'];
              double elo = teamlist[index]['elo']?.toDouble() ?? 0.0;
              return ListTile(
                title: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ViewProfile(widget.teamsnapshot,
                            widget.playersnapshot, teamlist[index]['id']);
                      },
                    );
                  },
                  child: Center(
                    child: SizedBox(
                      height: media.width * 0.17,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Use Row for horizontal layout
                        mainAxisAlignment: MainAxisAlignment
                            .spaceAround, // Align items vertically
                        children: [
                          Text("$rank",
                              style: TextStyle(
                                  fontSize: 20, color: TColor.primaryColor1)),
                          const SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              "assets/img/profilepic.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            // Expand text section to take remaining space
                            child: Text(
                              playername,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "${elo.round()}",
                            style: TextStyle(
                              color: TColor.gray,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else
        return Container();
    });
  }
}
