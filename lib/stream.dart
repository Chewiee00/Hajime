import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';

import 'package:flutter_test1/tabs/features/main_tab.dart';
import 'package:flutter_test1/tabs/profile/profile_tab.dart';

import 'package:provider/provider.dart';

class StreamTabView extends StatefulWidget {
  const StreamTabView({super.key});
  @override
  State<StreamTabView> createState() => _StreamTabViewState();
}

class _StreamTabViewState extends State<StreamTabView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> playerStream =
        context.watch<PlayerProvider>().players;
    Stream<QuerySnapshot> teamStream = context.watch<TeamProvider>().teams;

    return StreamBuilder(
        stream: playerStream,
        builder: (context, playersnapshot) {
          if (playersnapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${playersnapshot.error}"),
            );
          } else if (playersnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!playersnapshot.hasData) {
            return const Center(
              child: Text("No Players Found"),
            );
          }
          return StreamBuilder<Object>(
              stream: teamStream,
              builder: (context, teamsnapshot) {
                if (teamsnapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${teamsnapshot.error}"),
                  );
                } else if (teamsnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!teamsnapshot.hasData) {
                  return const Center(
                    child: Text("No Todos Found"),
                  );
                }

                return Maintab(
                    teamsnapshot, teamStream, playersnapshot, playerStream);
              });
        });
  }
}
