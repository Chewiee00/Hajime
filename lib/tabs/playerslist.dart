import 'package:flutter/material.dart';

import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/model/team_model.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';

import 'package:flutter_test1/tabs/profile/playerlist_profile.dart';

import 'package:provider/provider.dart';

class PlayersViewPage extends StatefulWidget {
  PlayersViewPage(this.user, this.playersnapshot, this.teamsnapshot,
      this.playerStream, this.teamStream,
      {super.key});
  final dynamic playersnapshot;
  Stream playerStream;
  Stream teamStream;
  final dynamic teamsnapshot;
  final Map<String, dynamic>? user;
  @override
  State<PlayersViewPage> createState() => _PlayersViewPageState();
}

class _PlayersViewPageState extends State<PlayersViewPage> {
  TextEditingController editingController = TextEditingController();
  String toSearch = "";
  String name = "";
  List<dynamic> filteredMatches = [];
  // late Map<String, dynamic> loser;
  // Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    filteredMatches = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search player',
                hintStyle: TextStyle(fontSize: 16.0),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          )),
      body: widget.user?["players"].isNotEmpty
          ? ListView.builder(
              itemCount: widget.playersnapshot.data?.docs.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthenticationProvider>().signOut();
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Text('Sign Out')),
                  ));
                }

                int playerindex = index - 1;
                Player user = Player.fromJson(
                    widget.playersnapshot.data?.docs[playerindex].data()
                        as Map<String, dynamic>);
                // print(user.id);
                if (name.isEmpty && widget.user!['players'].contains(user.id)) {
                  print(user.displayname);
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ViewProfile(widget.teamsnapshot,
                                widget.playersnapshot, user.id);
                          },
                        );
                      },
                      child: Text(
                        user.displayname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Warning"),
                                  content: Text(
                                      "By clicking 'OK', you will permanently remove ${user.displayname} from the team. This action will reset their Elo rating and delete all attendance and match history associated with this team. Are you sure you want to proceed?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Team teaminstance =
                                            Team.fromJson(widget.user!);
                                        //Remove player in team
                                        context
                                            .read<TeamProvider>()
                                            .selectUser(teaminstance);
                                        context
                                            .read<TeamProvider>()
                                            .removePlayer(user.id);
                                        //remove the matchlogs and attendance logs
                                        context
                                            .read<PlayerProvider>()
                                            .selectUser(user);
                                        context
                                            .read<PlayerProvider>()
                                            .removelogs();
                                        context
                                            .read<PlayerProvider>()
                                            .resetElo();
                                        context
                                            .read<PlayerProvider>()
                                            .removeTeam();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '${user.displayname} was successfuly removed from the team!')));
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
                        child: const Text("Remove")),
                  );
                }

                if (user.displayname
                        .toString()
                        .toLowerCase()
                        .startsWith(name.toLowerCase()) &&
                    widget.user!['players'].contains(user.id)) {
                  return ListTile(
                      title: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ViewProfile(widget.teamsnapshot,
                                  widget.playersnapshot, user.id);
                            },
                          );
                        },
                        child: Text(
                          user.displayname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Warning"),
                                  content: Text(
                                      "By clicking 'OK', you will permanently remove ${user.displayname} from the team. This action will reset their Elo rating and delete all attendance and match history associated with this team. Are you sure you want to proceed?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Team teaminstance =
                                            Team.fromJson(widget.user!);
                                        //Remove player in team
                                        context
                                            .read<TeamProvider>()
                                            .selectUser(teaminstance);
                                        context
                                            .read<TeamProvider>()
                                            .removePlayer(user.id);
                                        //remove the matchlogs and attendance logs
                                        context
                                            .read<PlayerProvider>()
                                            .selectUser(user);
                                        context
                                            .read<PlayerProvider>()
                                            .removelogs();
                                        context
                                            .read<PlayerProvider>()
                                            .resetElo();
                                        context
                                            .read<PlayerProvider>()
                                            .removeTeam();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '${user.displayname} was successfuly removed from the team!')));
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
                        child: const Text("Remove"),
                      ));
                }

                return Container();
              })
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: Text('No members')),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationProvider>().signOut();
                    Navigator.pushNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Sign Out'))
            ]),
    );
  }
}
