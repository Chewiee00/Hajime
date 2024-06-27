import 'package:flutter/material.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/tabs/qr/qrgenerator_tab.dart';
import 'package:flutter_test1/tabs/qr/qrscanner_tab.dart';
import 'package:provider/provider.dart';

class QRTabView extends StatefulWidget {
  final teamsnapshot;
  final playersnapshot;
  final Stream playerStream;
  final Stream teamStream;
  const QRTabView(this.teamsnapshot, this.teamStream, this.playersnapshot,
      this.playerStream,
      {super.key});

  @override
  State<QRTabView> createState() => _QRTabViewState();
}

class _QRTabViewState extends State<QRTabView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      Map<String, dynamic>? user;
      // Team? playeruser;
      int? userType;
      for (int i = 0; i < widget.teamsnapshot.data?.docs.length; i++) {
        // user = Team.fromJson(widget.teamsnapshot.data?.docs[i].data()
        //     as Map<String, dynamic>) as Map<String, dynamic>;
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
          // user = Player.fromJson(widget.playersnapshot.data?.docs[i].data()
          //     as Map<String, dynamic>) as Map<String, dynamic>?;
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

      if (userType == 0) {
        return QRGeneratorPage(user);
      } else if (userType == 1) {
        return QRCodeScanner(user, widget.playersnapshot, widget.teamsnapshot);
      }
      return Container();
    }));
  }
}
