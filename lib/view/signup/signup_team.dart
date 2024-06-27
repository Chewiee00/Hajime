import 'package:alert_dialog/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';
import 'package:flutter_test1/common_widgets/round_textfield.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/stream.dart';
import 'package:flutter_test1/view/login/login_view.dart';
import 'package:flutter_test1/view/signup/select_user_type_view.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SignupTeamView extends StatefulWidget {
  const SignupTeamView({super.key});

  @override
  State<SignupTeamView> createState() => _SignupTeamViewState();
}

class _SignupTeamViewState extends State<SignupTeamView> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _teamnameController;
  // late TextEditingController _addressController;
  // late TextEditingController _contactnumberController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _teamnameController = TextEditingController();
    // _addressController = TextEditingController();
    // _contactnumberController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _teamnameController.dispose();
    // _addressController.dispose();
    // _contactnumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: TColor.white,
        body: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                Text("Hello Coach,",
                    style: TextStyle(color: TColor.gray, fontSize: 20)),
                Text("Create A Team Account",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: validateEmail,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                ),
                RoundTextField(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  controller: _passwordController,
                  validator: validatePassword,
                  obscureText: true,
                ),
                // SizedBox(
                //   height: media.width * 0.08,
                // ),
                // Text("Let us know more about you.",
                //     style: TextStyle(
                //         color: TColor.black,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w700)),
                // SizedBox(
                //   height: media.width * 0.08,
                // ),
                RoundTextField(
                  hintText: "Team Name",
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  controller: _teamnameController,
                  validator: validateTeamname,
                ),
                // RoundTextField(
                //   hintText: "Address",
                //   controller: _addressController,
                //   validator: validateAddress,
                //   margin: const EdgeInsets.symmetric(
                //     vertical: 10,
                //   ),
                // ),
                // RoundTextField(
                //   hintText: "Contact Number",
                //   controller: _contactnumberController,
                //   keyboardType: TextInputType.phone,
                //   validator: validatePhoneContact,
                //   margin: const EdgeInsets.symmetric(
                //     vertical: 10,
                //   ),
                // ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                RoundButton(
                    title: "Sign Up",
                    type: RoundButtonType.bgGradient,
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        _key.currentState?.save();
                        final authProvider =
                            context.read<AuthenticationProvider>();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        Random random = Random();

                        const String chars =
                            'abcdefghijklmnopqrstuvwxyz0123456789'; // Define characters to choose from

                        String code = '';
                        for (int i = 0; i < 6; i++) {
                          code += chars[random.nextInt(chars
                              .length)]; // Select a random character from chars
                        }

                        Map<String, dynamic> newTeam = {
                          "name": _teamnameController.text,
                          "code": code
                          // "contactnumber": _contactnumberController.text,
                          // "address": _addressController.text,
                        };

                        await authProvider
                            .signUp(email, password, 0, newTeam)
                            .then((value) {
                          if (value ==
                              'The account already exists for that email.') {
                            alert(context, title: Text(value));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Jump to the Login page
                                builder: (context) => const StreamTabView(),
                              ),
                            );
                          }
                        });
                      }
                    }),
                SizedBox(
                  height: media.width * 0.1,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Jump to the Login page
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )),
          ),
        ));
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';
  return null;
}

String? validateTeamname(String? formfirstname) {
  if (formfirstname == null || formfirstname.trim().isEmpty) {
    return 'Team Name is required.';
  }
  return null;
}

String? validateAddress(String? address) {
  if (address == null || address.trim().isEmpty) {
    return 'Address is required.';
  }
  return null;
}

String? validatePassword(String? formpassword) {
  if (formpassword == null || formpassword.isEmpty) {
    return 'Password is required.';
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formpassword)) {
    return '''
      Password must be at least 6 characters,
      include an uppercase letter, number and symbol.
      ''';
  }

  return null;
}

String? validatePhoneContact(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.trim().isEmpty) {
    return 'Phone number is required.';
  }

  RegExp phoneRegex = RegExp(r'^(09|\+639)\d{9}$');
  if (!phoneRegex.hasMatch(phoneNumber)) {
    return 'Invalid phone number format. Please use 0XXXXXXXXX.';
  }

  return null;
}
