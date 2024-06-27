import 'package:flutter/material.dart';
import 'package:flutter_test1/provider/auth_provider.dart';
import 'package:flutter_test1/provider/player_provider.dart';
import 'package:flutter_test1/provider/team_provider.dart';
import 'package:flutter_test1/stream.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test1/view/login/login_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'common/color_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => AuthenticationProvider())),
      ChangeNotifierProvider(create: ((context) => TeamProvider())),
      ChangeNotifierProvider(create: ((context) => PlayerProvider()))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAJIME JUDO APP',
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginView(),
        '/maintab': (context) => StreamTabView(),
      },
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins"),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
          const Duration(seconds: 2)), // Adjust delay duration as needed
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the delay, show a loading indicator
          return const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
        } else {
          if (context.watch<AuthenticationProvider>().isAuthenticated) {
            return const StreamTabView();
          } else {
            return const LoginView();
          }
        }
      },
    );
  }
}
