import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchesViewPage extends StatefulWidget {
  MatchesViewPage(this.user, {super.key});
  final Map<String, dynamic>? user;
  // int userType;
  // String? userid;
  @override
  State<MatchesViewPage> createState() => _MatchesViewPageState();
}

class _MatchesViewPageState extends State<MatchesViewPage> {
  String name = "";
  List<dynamic> filteredMatches = [];
  late Map<String, dynamic> loser;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    filteredMatches = widget.user?['matchlogs'].reversed.toList();
    [];
  }

  // Future<Map<String, dynamic>> getUserdata() async {
  //   Map<String, dynamic>? userData;
  //   if (widget.userType == 1) {
  //     userData = await context
  //         .read<PlayerProvider>()
  //         .viewSpecificPlayer(widget.userid);
  //   }
  //   if (widget.userType == 0) {
  //     userData = await context
  //         .read<TeamProvider>()
  //         .viewSpecificTeam(context.read<AuthenticationProvider>().getUser());
  //   }
  //   return userData!;
  // }

  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search match',
                hintStyle: TextStyle(fontSize: 16.0),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                  if (val.isNotEmpty) {
                    filteredMatches = widget.user?['matchlogs']
                        .where((log) => log
                            .toString()
                            .toLowerCase()
                            .contains(val.toLowerCase()))
                        .toList();
                  } else {
                    filteredMatches =
                        widget.user?['matchlogs'].reversed.toList() ??
                            []; // Reset to original logs
                  }
                });
              },
            ),
          )),
      body: filteredMatches.isNotEmpty
          ? ListView.builder(
              itemCount: filteredMatches.length,
              itemBuilder: (context, index) {
                List<String> logs = filteredMatches[index].split(":");
                String date = logs[0];
                String winnername = logs[1].split("-")[0].split(" ")[0];
                String losername = logs[2].split("-")[0].split(" ")[0];
                String winnerweight = "${logs[1].split("-")[1]} kg";
                String loserweight = "${logs[2].split("-")[1]} kg";
                // print(logs[3]);
                String addedElo = logs[3];
                // Parse the date string into a DateTime object
                int day = DateFormat('MMMM d, yyyy').parse(date).weekday;
                String dayofdate = "";

                switch (day) {
                  case 0:
                    dayofdate = "Mon";
                    break;
                  case 1:
                    dayofdate = "Teus";
                    break;
                  case 2:
                    dayofdate = "Wed";
                    break;
                  case 3:
                    dayofdate = "Thu";
                    break;
                  case 4:
                    dayofdate = "Fri";
                    break;
                  case 5:
                    dayofdate = "Sat";
                    break;
                  case 6:
                    dayofdate = "Sun";
                    break;

                  default:
                    dayofdate = "";
                }

                return ListTile(
                  title: Center(
                    child: Column(
                      children: [
                        Container(
                          height: media.width * 0.07,
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 25, horizontal: 15),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              borderRadius:
                                  BorderRadius.circular(media.width * 0.015),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 5),
                                    color: TColor.primaryColor1.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 115, 227, 119),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text("Winner",
                                              style: TextStyle(
                                                  color: TColor.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 231, 119, 111),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text("Loser",
                                              style: TextStyle(
                                                  color: TColor.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: media.width * 0.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              borderRadius:
                                  BorderRadius.circular(media.width * 0.015),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 5),
                                    color: TColor.primaryColor1.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: TColor.lightGray,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            child: Image.asset(
                                              "assets/img/profilepic.png",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(winnername,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: TColor.gray,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              Text("+$addedElo Elo ",
                                                  style: TextStyle(
                                                      color: TColor.gray
                                                          .withOpacity(0.7),
                                                      fontSize: 16))
                                            ],
                                          ),
                                          // Text("+$addedElo",
                                          //     style: TextStyle(
                                          //         color: TColor.gray,
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.w700))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: TColor.primaryColor1,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Text("-$addedElo",
                                          //     style: TextStyle(
                                          //         color: TColor.white,
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.w700)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(losername,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: TColor.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              Center(
                                                child: Text("-$addedElo Elo",
                                                    style: TextStyle(
                                                        color: TColor.white
                                                            .withOpacity(0.7),
                                                        fontSize: 16)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ClipRRect(
                                            child: Image.asset(
                                              "assets/img/profilepic.png",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * .01,
                        ),
                        Container(
                          height: media.width * 0.1,
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 25, horizontal: 15),
                          decoration: BoxDecoration(
                              color: TColor.gray.withOpacity(.2),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 5),
                                    color: TColor.primaryColor1.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 10)
                              ]),
                          child: Center(
                            child: Text(date,
                                style: TextStyle(
                                    color: TColor.white, fontSize: 16)),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('No matching logs found')),
    );
  }
}
