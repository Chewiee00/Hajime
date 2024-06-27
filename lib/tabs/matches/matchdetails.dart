import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/model/team_model.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class MatchDetailsAlertDialog extends StatefulWidget {
  const MatchDetailsAlertDialog(this.user, this.playerSnapshot, {Key? key})
      : super(key: key);
  final dynamic playerSnapshot;
  final Map<String, dynamic>? user;
  @override
  State<MatchDetailsAlertDialog> createState() =>
      _MatchDetailsAlertDialogState();
}

class _MatchDetailsAlertDialogState extends State<MatchDetailsAlertDialog> {
  late TextEditingController _player1Controller;
  late TextEditingController _player2Controller;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? _selectedPlayer1;
  String? _selectedPlayer2;
  double p1old = 0.0;
  double p2old = 0.0;
  double p1new = 0.0;
  double p2new = 0.0;
  Map<String, dynamic>? player1;
  Map<String, dynamic>? player2;
  List<Map<String, dynamic>> teamList = [];
  bool _isLoading = false; // Assuming you have some data here
  @override
  void initState() {
    super.initState();
    _player1Controller = TextEditingController();
    _player2Controller = TextEditingController();
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  Future<void> printPlayerData(winner_id, loser_id) async {
    Future<Map<String, dynamic>?> winner =
        context.read<PlayerProvider>().viewSpecificPlayer(winner_id);

    Future<Map<String, dynamic>?> loser =
        context.read<PlayerProvider>().viewSpecificPlayer(loser_id);

    Map<String, dynamic>? loserData = await loser;
    Map<String, dynamic>? winnerData = await winner;
    print(winnerData);
    print(loserData);
    setState(() {
      p1old = winnerData?['elo'].toDouble();
      p2old = loserData?['elo'].toDouble();
    });
  }

  Future<void> matchdetails(double p1new, double p2new, int added) async {
    String matchlog =
        "${DateFormat('MMMM d, yyyy').format(DateTime.now())}:${player1?['displayname']}-${player1?['weight']}:${player2?['displayname']}-${player2?['weight']}:$added:${player1?['id']}:${player2?['id']}";
    context.read<PlayerProvider>().selectUser(Player.fromJson(player1!));
    context.read<PlayerProvider>().editElo(p1new);
    context.read<PlayerProvider>().addMatchlog(matchlog);

    context.read<PlayerProvider>().selectUser(Player.fromJson(player2!));
    context.read<PlayerProvider>().editElo(p2new);
    context.read<PlayerProvider>().addMatchlog(matchlog);

    context.read<TeamProvider>().selectUser(Team.fromJson(widget.user!));
    context.read<TeamProvider>().addMatchlog(matchlog);

    print("Match detail update success!");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? player;
    List<Map<String, dynamic>> teamList = [];
    List<String> stringOfPlayers = [];

    return Builder(builder: (context) {
      for (int i = 0; i < widget.playerSnapshot.data?.docs.length; i++) {
        player =
            widget.playerSnapshot.data?.docs[i].data() as Map<String, dynamic>;

        if (widget.user?['players'].contains(player?['id'])) {
          teamList.add(player!);
          stringOfPlayers.add(player?['displayname']);
        }
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Create a Match'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AlertDialog(
                title: Text("Instructions"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Before the Match:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '- All players must agree to the match being recorded.',
                    ),
                    Text(
                      '\nAfter the Match:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '1. The coach must enter the winner and loser in the match details form below. \n2. The first text button is for selecting the winner.\n3. The second text button is for selecting the loser. \n4. Press the submit button to update the ratings',
                    ),
                  ],
                ),
              ),
              AlertDialog(
                title: const Text('Match Details'),
                content: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _player1Controller,
                        validator: validateSelect1,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            color: _selectedPlayer1 != null
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16,
                          ),
                          hintText: "Press to Select the Winner",
                        ),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Select Winner'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...teamList
                                        .where((name) =>
                                            name["displayname"] !=
                                            _selectedPlayer2)
                                        .map(
                                          (name) => ListTile(
                                            title: Text(name["displayname"]),
                                            onTap: () {
                                              setState(() {
                                                _selectedPlayer1 =
                                                    name["displayname"];
                                                _player1Controller.text =
                                                    name["displayname"];
                                                player1 = name;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      TextFormField(
                        controller: _player2Controller,
                        validator: validateSelect2,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            color: _selectedPlayer1 != null
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16,
                          ),
                          hintText: "Press to Select the Loser",
                        ),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Select Loser'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...teamList
                                          .where((name) =>
                                              name["displayname"] !=
                                              _selectedPlayer1)
                                          .map(
                                            (name) => ListTile(
                                              title: Text(name["displayname"]),
                                              onTap: () {
                                                setState(() {
                                                  _selectedPlayer2 =
                                                      name["displayname"];
                                                  _player2Controller.text =
                                                      name["displayname"];
                                                  player2 = name;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Match"),
                              content: Text(
                                  "By submitting, you confirm that the matched players are final and correct.\n\nWinner - ${_selectedPlayer1}\nLoser - ${_selectedPlayer2}"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading =
                                          true; // Show loading indicator
                                    });
                                    if (player1?["id"] == null ||
                                        player2?["id"] == null) {
                                      Navigator.of(context).pop();
                                      alert(context,
                                          title: Text("Please select players"));
                                    } else {
                                      await printPlayerData(
                                          player1?["id"], player2?["id"]);

                                      double k = 40;
                                      double p1weight = double.parse(
                                          player1?['weight'] ?? '0');
                                      double p2weight = double.parse(
                                          player2?['weight'] ?? '0');

                                      DateTime p1start =
                                          DateFormat("yyyy-MM-dd").parse(
                                              player1?["trainingdateStart"] ??
                                                  '1970-01-01');
                                      DateTime p2start =
                                          DateFormat("yyyy-MM-dd").parse(
                                              player2?["trainingdateStart"] ??
                                                  '1970-01-01');

                                      double p1training =
                                          calculateMonthsDifference(p1start)
                                              .toDouble();
                                      double p2training =
                                          calculateMonthsDifference(p2start)
                                              .toDouble();

                                      setState(() {
                                        p1new = p1old +
                                            k *
                                                (1 -
                                                    (1 /
                                                        (1 +
                                                            (pow(
                                                                10,
                                                                ((p2training -
                                                                            p1training) +
                                                                        (p2old -
                                                                            p1old) +
                                                                        10 *
                                                                            (p2weight -
                                                                                p1weight)) /
                                                                    400)))));
                                        p2new = p2old +
                                            k *
                                                (0 -
                                                    (1 /
                                                        (1 +
                                                            (pow(
                                                                10,
                                                                ((p1training -
                                                                            p2training) +
                                                                        (p1old -
                                                                            p2old) +
                                                                        10 *
                                                                            (p1weight -
                                                                                p2weight)) /
                                                                    400)))));
                                      });

                                      await matchdetails(p1new, p2new,
                                          (p1new - p1old).toInt());

                                      setState(() {
                                        _isLoading =
                                            false; // Show loading indicator
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Match make success!')));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text("Confirm"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                    child:
                        _isLoading // Show loading indicator if _isLoading is true
                            ? CircularProgressIndicator()
                            : Text("Submit"),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text("Cancel"),
                  //   style: TextButton.styleFrom(
                  //     textStyle: Theme.of(context).textTheme.bodyText1,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  int calculateMonthsDifference(DateTime startDate) {
    DateTime currentDate = DateTime.now();
    int monthsDifference = currentDate.month - startDate.month;
    int yearsDifference = currentDate.year - startDate.year;
    return monthsDifference + (yearsDifference * 12);
  }
}

String? validateSelect1(String? selectedItem) {
  if (selectedItem == null || selectedItem.isEmpty) {
    return 'Please select a player 1.';
  }
  return null;
}

String? validateSelect2(String? selectedItem) {
  if (selectedItem == null || selectedItem.isEmpty) {
    return 'Please select a player 2.';
  }
  return null;
}
