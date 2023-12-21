import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'on_boarding_screen.dart';  // Replace with your onboarding screen file path
import 'home.dart';               // Replace with your home screen file path
import 'choose_action_page.dart'; // Replace with your choose action page file path

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: checkFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();  // Or some other loading indicator
          }

          if (snapshot.data ?? false) {
            // First launch and onboarding not complete, show OnboardingScreen
            return OnboardingScreen(onBoardingComplete: () {
              setOnboardingComplete();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ChooseActionPage()),
              );
            });
          } else {
            // Not first launch or onboarding complete, proceed to check login
            return CheckLogin();
          }
        },
      ),
    );
  }

  Future<bool> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    return firstLaunch && !onboardingComplete;
  }

  void setOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
    await prefs.setBool('onboardingComplete', true);
  }
}

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data ?? false) {
          return MyHomePage(title: 'Home');  // User is logged in, show home page
        } else {
          return ChooseActionPage();  // Not logged in, show sign up or log in page
        }
      },
    );
  }

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
