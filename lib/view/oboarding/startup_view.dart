import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/tabs/blank_tab.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: TColor.white,
        body: Container(
            width: media.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(),
              Text("TITLE",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w700)),
              Text("Description",
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 18,
                  )),
              const Spacer(),
              SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: RoundButton(
                        title: "Get Started",
                        type: RoundButtonType.textGradient,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // Jump to the Login and Signup page
                                  builder: (context) => const BlankTabView()));
                        })),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
            ])));
  }
}
