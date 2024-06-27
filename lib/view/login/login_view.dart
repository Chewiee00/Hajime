import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';
import 'package:flutter_test1/common_widgets/round_button.dart';
import 'package:flutter_test1/common_widgets/round_textfield.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/view/signup/select_user_type_view.dart';
import 'package:provider/provider.dart';
import 'package:alert_dialog/alert_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
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
          child: Center(
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(children: [
                  Text("Welcome back Judoka,",
                      style: TextStyle(color: TColor.gray, fontSize: 20)),
                  Text("Login",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  RoundTextField(
                    controller: emailController,
                    validator: validateEmail,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                  RoundTextField(
                    controller: passwordController,
                    validator: validatePassword,
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundButton(
                    title: "Login",
                    type: RoundButtonType.bgGradient,
                    onPressed: () async {
                      try {
                        if (_key.currentState!.validate()) {
                          _key.currentState?.save();
                          await context
                              .read<AuthenticationProvider>()
                              .signIn(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value == 'No user found for that email' ||
                                value ==
                                    'Wrong password provided for that user.' ||
                                value == 'invalid-credential') {
                              alert(context, title: Text(value));
                            }
                            print(value);
                          });
                          // Navigator.pushNamed(context, '/');
                          // setState(() {});
                        }
                      } catch (e) {
                        // Catch any exceptions that might occur during sign-in
                        print("Exception occurred: $e");
                        // Handle the exception as required
                      }
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            width: double.maxFinite,
                            height: 1,
                            color: TColor.gray.withOpacity(0.5)),
                      ),
                      Text("  Or  ",
                          style: TextStyle(color: TColor.black, fontSize: 12)),
                      Expanded(
                        child: Container(
                            width: double.maxFinite,
                            height: 1,
                            color: TColor.gray.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                // Jump to the Login and Signup page
                                builder: (context) => const SelectUserType()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Doesn't have an account? ",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                              )),
                          Text("Register",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ))
                ]),
              )),
            ),
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

String? validatePassword(String? formlastname) {
  if (formlastname == null || formlastname.trim().isEmpty) {
    return 'Password is required.';
  }

  return null;
}
