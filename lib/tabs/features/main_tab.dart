import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/tabs/home/home_tab.dart';
import 'package:flutter_test1/tabs/profile/profile_tab.dart';
import 'package:flutter_test1/tabs/qr/qr_tab.dart';
import 'package:provider/provider.dart';

class Maintab extends StatefulWidget {
  final dynamic teamsnapshot;
  final Stream teamStream;
  final dynamic playersnapshot;
  final Stream playerStream;
  const Maintab(this.teamsnapshot, this.teamStream, this.playersnapshot,
      this.playerStream,
      {super.key});

  @override
  State<Maintab> createState() => _MaintabState();
}

class _MaintabState extends State<Maintab> {
  late int selectTab;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    selectTab = 2;
    // currentTab = HomeTabView(widget.teamsnapshot, widget.teamStream,
    //     widget.playersnapshot, widget.playerStream);
  }

  static const IconData qr_code_scanner_rounded =
      IconData(0xf00cc, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        backgroundColor: TColor.white,
        body: TabBarView(
          children: <Widget>[
            ProfileTabView(widget.teamsnapshot, widget.teamStream,
                widget.playersnapshot, widget.playerStream),
            HomeTabView(widget.teamsnapshot, widget.teamStream,
                widget.playersnapshot, widget.playerStream)
          ],
        ),
        // drawer: Drawer(
        //     child: ListView(padding: EdgeInsets.zero, children: [
        //   ListTile(
        //     title: const Text('Logout'),
        //     onTap: () {
        //       context.read<AuthenticationProvider>().signOut();
        //       Navigator.pushNamed(context, '/');
        //     },
        //   ),
        // ])),
        appBar: AppBar(
            elevation: 0,
            // automaticallyImplyLeading: false,
            title: Image.asset(
              "assets/img/applogo.png",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            backgroundColor: TColor.white,
            centerTitle: true,
            leadingWidth: 0,
            leading: const SizedBox(),
            actions: [
              // IconButton(
              //     onPressed: () {
              //       context.read<AuthenticationProvider>().signOut();

              //       Navigator.pushNamed(context, '/');
              //     },
              //     icon: const Icon(Icons.logout))
            ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // Jump to the Login and Signup page
                          builder: (context) => QRTabView(
                              widget.teamsnapshot,
                              widget.teamStream,
                              widget.playersnapshot,
                              widget.playerStream)));
                },
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: TColor.secondaryG,
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(qr_code_scanner_rounded,
                      color: TColor.white, size: 35),
                ))),
        bottomNavigationBar: TabBar(
          isScrollable: false,
          indicatorColor: TColor.primaryColor1, // Color when selected
          unselectedLabelColor: TColor.gray, // Color when not selected
          labelColor: TColor.secondaryColor1, // Color when selected
          tabs: [
            Tab(
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            Tab(
                child: Icon(
              Icons.home,
              size: 40,
            )),
          ],
        ),
      ),
    );
  }
}
