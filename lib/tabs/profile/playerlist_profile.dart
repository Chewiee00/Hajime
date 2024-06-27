import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/tabs/attendances/attendance_tab.dart';
import 'package:flutter_test1/tabs/matches/matches_tab.dart';
import 'package:flutter_test1/tabs/profile/profile_data.dart';

class ViewProfile extends StatefulWidget {
  final teamsnapshot;
  final playersnapshot;
  final String? userid;
  ViewProfile(
    this.teamsnapshot,
    this.playersnapshot,
    this.userid,
  );

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
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

  @override
  Widget build(BuildContext context) {
    int userType = 1;
    return Scaffold(
        backgroundColor: TColor.white,
        body: Builder(builder: (context) {
          if (user == null) {
            for (int i = 0; i < widget.playersnapshot.data?.docs.length; i++) {
              // user = Player.fromJson(widget.playersnapshot.data?.docs[i].data()
              //     as Map<String, dynamic>) as Map<String, dynamic>?;
              user = widget.playersnapshot.data?.docs[i].data()
                  as Map<String, dynamic>;
              if (user?['id'] == widget.userid) {
                print(user);
                userType = 1;
                break;
              } else {
                user = null;
              }
            }
          }

          String displayname = user?["displayname"];
          String teamname = user?["teamname"] ?? "null";

          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
            ),
            body: Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayname,
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (hasTeam)
                                        Text(
                                          teamname,
                                          style: TextStyle(
                                            color: TColor.gray,
                                            fontSize: 14,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Container(
                      height: 56.0,
                      child: const TabBar(
                        tabs: [
                          Tab(
                              child: Text(
                            "Personal Data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                          Tab(
                              child: Text(
                            "Match History",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                          Tab(
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
                        ProfileData(user, 1),
                        MatchesViewPage(user),
                        AttendanceTab(user),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
