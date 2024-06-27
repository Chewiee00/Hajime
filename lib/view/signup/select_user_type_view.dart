import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/view/signup/signup_student.dart';
import 'package:flutter_test1/view/signup/signup_team.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: TColor.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(children: [
              Text("Let's Go,",
                  style: TextStyle(color: TColor.gray, fontSize: 20)),
              Text("Get started as a...",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: media.width * 0.1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // Jump to the Login and Signup page
                            builder: (context) => const SignupTeamView()));
                  },
                  child: Image.asset(
                    'assets/img/Team.png',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // Jump to the Login and Signup page
                          builder: (context) => const SignupStudentView()));
                },
                child: Image.asset(
                  'assets/img/Student.png', // Replace with your image asset path
                  // Adjust height as needed
                ),
              ),
            ]),
          ),
        )));
  }
}
