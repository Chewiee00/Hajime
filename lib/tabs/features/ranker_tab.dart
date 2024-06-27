import 'package:flutter/material.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';
import 'package:flutter_test1/tabs/matches/matchdetails.dart';

class RankerViewPage extends StatefulWidget {
  const RankerViewPage(this.user, this.playerSnapshot, {Key? key})
      : super(key: key);

  final dynamic playerSnapshot;
  final Map<String, dynamic>? user;

  @override
  State<RankerViewPage> createState() => _RankerViewPageState();
}

class _RankerViewPageState extends State<RankerViewPage> {
  late TextEditingController _player1Controller;
  late TextEditingController _player2Controller;
  Map<String, dynamic>? player1;
  Map<String, dynamic>? player2;

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

  Widget build(BuildContext context) {
    Map<String, dynamic>? player;
    List<Map<String, dynamic>> teamList = [];
    List<String> stringOfPlayers = [];

    for (int i = 0; i < widget.playerSnapshot.data?.docs.length; i++) {
      player =
          widget.playerSnapshot.data?.docs[i].data() as Map<String, dynamic>;
      if (widget.user?['players'].contains(player['id'])) {
        teamList.add(player);
        stringOfPlayers.add(player['displayname']);
      }
    }

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            RoundButton(
              title: "Create a match",
              type: RoundButtonType.bgGradient,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => MatchDetailsAlertDialog(
                        widget.user, widget.playerSnapshot));
              },
            ),
          ],
        ),
      ),
    );
  }
}
