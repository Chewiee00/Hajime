import 'dart:async';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';
import 'package:flutter_test1/model/player_model.dart';
import 'package:flutter_test1/model/team_model.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_to_act/slide_to_act.dart'; // Import for permissions

class QRCodeScanner extends StatefulWidget {
  final Map<String, dynamic>? user;
  final teamsnapshot;
  final playersnapshot;
  const QRCodeScanner(this.user, this.playersnapshot, this.teamsnapshot,
      {super.key});

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? scanResult;
  String _buttonname = 'Check Out';
  String _currentTime = '';
  String _checkin = '--:--';
  String _checkout = '--:--';
  bool buttonDisabled = false;
  bool isLoading = false;
  String? scanError;
  String _checkinlog = '';
  String _intime = '';
  String _indate = '';
  String _outtime = '';
  Map<String, dynamic>? team;
  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  Future<void> _scanQR() async {
    setState(() => isLoading = true);
    var status = await Permission.camera.request();
    if (status.isGranted) {
      String? result = await scanner.scan();
      if (mounted) {
        // setState(() => scanResult = result);
        for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
          team =
              widget.teamsnapshot.data?.docs[i].data() as Map<String, dynamic>;
          if (team!['id'] == result) {
            break;
          } else {
            team = null;
          }
        }
        // print("here");
        if (team != null && (team?['name'] == widget.user?['teamname'])) {
          setState(() {
            _checkin = DateFormat('kk:mm').format(DateTime.now());
            _intime = DateFormat('kk:mm').format(DateTime.now());
            _indate = DateFormat('MMMM d, yyyy').format(DateTime.now());
            _checkinlog =
                "${DateFormat('MMMM d, yyyy').format(DateTime.now())}-In:${DateFormat('kk:mm').format(DateTime.now())}-null-${widget.user!["displayname"]}";
          });
          print(widget.user);
          Player playerinstance = Player.fromJson(widget.user!);
          String log = _checkinlog;
          Team teaminstance = Team.fromJson(team!);
          await _checkinLog(playerinstance, teaminstance, log);
        } else {
          alert(context, title: Text("Invalid QR code!"));
        }
      }
    } else {
      setState(() => scanError = "Permission Denied");
    }
  }

  Future<void> _checkinLog(
      Player playerinstance, Team teaminstance, String log) async {
    context.read<PlayerProvider>().selectUser(playerinstance);
    context.read<TeamProvider>().selectUser(teaminstance);
    context.read<TeamProvider>().addLog(log);
    context.read<PlayerProvider>().addLog(log);
    print("Checkin Success!");
  }

  Future<void> _checkoutLog(Player playerinstance, Team teaminstance,
      String oldlog, String newlog) async {
    context.read<PlayerProvider>().selectUser(playerinstance);
    context.read<PlayerProvider>().removeLog(oldlog);
    context.read<PlayerProvider>().addLog(newlog);

    context.read<TeamProvider>().selectUser(teaminstance);
    context.read<TeamProvider>().removeLog(oldlog);
    context.read<TeamProvider>().addLog(newlog);
    print("Checkout Success!");
  }

  Future checkout() async {
    setState(() {
      _checkout = DateFormat('kk:mm').format(DateTime.now());
      buttonDisabled = true;
      _buttonname = "Success!";
      _outtime = DateFormat('kk:mm').format(DateTime.now());
      scanResult = "You're done for today!";
    });
    for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
      team = widget.teamsnapshot.data?.docs[i].data() as Map<String, dynamic>;
      if (team!['id'] == widget.user?['teamid']) {
        break;
      }
    }
    // print(widget.user!);
    Player playerinstance = Player.fromJson(widget.user!);

    Team teaminstance = Team.fromJson(team!);
    String oldlog = _checkinlog;
    String newlog =
        "$_indate-In:$_intime-Out:$_outtime-${widget.user!["displayname"]}";

    await _checkoutLog(playerinstance, teaminstance, oldlog, newlog);
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('MMMM d, yyyy - kk:mm').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Instructions',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Instructions"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'For Check-In:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Press the "Check In" button and then scan your team\'s unique QR code.',
                          ),
                          Text(
                            '\nFor Check-Out:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Slide the "Check Out" button.',
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: Text("I understand"),
                        ),
                      ],
                    );
                  },
                );
              })
        ],
      ),
      body: Builder(builder: (context) {
        List<dynamic>? attendancelogs = widget.user?["logs"];
        // Team? playeruser;
        for (int i = 0; i < attendancelogs!.length; i++) {
          if (attendancelogs[i].split("-")[0] ==
              DateFormat('MMMM d, yyyy').format(DateTime.now())) {
            _checkin = attendancelogs[i].split("-")[1].substring(3);
            _checkinlog = attendancelogs[i];
            _indate = attendancelogs[i].split("-")[0];
            _intime = _checkin;
            if (attendancelogs[i].split("-")[2] != "null") {
              _checkout = attendancelogs[i].split("-")[2].substring(4);
              buttonDisabled = true;
              _buttonname = "Youre done for today!";
              scanResult = "You're done for today!";
            }
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          child: Center(
            child: Column(
              children: [
                Text("Hey there!",
                    style: TextStyle(color: TColor.gray, fontSize: 16)),
                Text("Let us know you're here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: media.width * 0.2),
                Container(
                  height: media.width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text("Clock In",
                                    style: TextStyle(
                                        color: TColor.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Center(
                                child: Text(_checkin,
                                    style: TextStyle(
                                        color: TColor.white.withOpacity(0.7),
                                        fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text("Clock Out",
                                    style: TextStyle(
                                        color: TColor.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Center(
                                child: Text(_checkout,
                                    style: TextStyle(
                                        color: TColor.white.withOpacity(0.7),
                                        fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(_currentTime, style: const TextStyle(fontSize: 16)),
                SizedBox(height: media.width * 0.005),
                // if (scanResult != null)
                //   Text('$scanResult', style: TextStyle(fontSize: 16))
                // else
                //   const Text(''),
                const SizedBox(height: 20),
                if (_checkin == '--:--')
                  RoundButton(
                      title: "Clock In",
                      type: RoundButtonType.textGradient,
                      onPressed: () {
                        if (widget.user?['teamid'] == null) {
                          alert(context,
                              title: const Text("Please join a team first!"));
                        } else {
                          _scanQR();
                        }
                      })
                else if (buttonDisabled == false)
                  // RoundButton(
                  //     title: "Clock Out",
                  //     type: RoundButtonType.textGradient,
                  //     onPressed: checkout)
                  Center(
                    child: SlideAction(
                        borderRadius: 12,
                        elevation: 0,
                        innerColor: TColor.primaryColor1,
                        outerColor: TColor.primaryColor1.withOpacity(0.7),
                        text: "       Slide to Clock Out",
                        sliderButtonIcon: Icon(
                          Icons.timelapse,
                          color: TColor.white,
                        ),
                        textStyle: TextStyle(
                          color: TColor.white,
                          fontSize: 16,
                          // Center the text
                        ),
                        onSubmit: () {
                          print("slide");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    "Clock out - ${DateFormat('kk:mm').format(DateTime.now())}"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await checkout();
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text("Confirm"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
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
                            },
                          );
                        }),
                  )
                else
                  Center(
                      child: Container(
                    height: media.width * 0.1,
                    child: Center(
                        child: Text("$scanResult",
                            style:
                                TextStyle(fontSize: 16, color: TColor.gray))),
                    // padding: const EdgeInsets.symmetric(
                    //     vertical: 25, horizontal: 15),
                  ))
                // RoundButton(
                //   title: _buttonname,
                //   type: RoundButtonType.textGradient,
                //   onPressed: checkout,
                //   disabled: buttonDisabled,
                // )
              ],
            ),
          ),
        );
      }),
    );
  }
}
