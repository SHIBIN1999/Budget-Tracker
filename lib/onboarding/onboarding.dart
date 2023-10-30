import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:money_1/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  ///Changed a little bit of buttons styling and text for the thumbnail lol
  ///Thanks for coming here :-)

  final List<PageViewModel> pages = [
    PageViewModel(
        title: 'Be easier to manage your own money',
        body:
            'Just using your phone,you can manage all your cashflow more easy and detail',
        image: Center(
          child: Lottie.asset(
            'animations/animation_lng5q21m.json',
            width: 500,
            height: 400,
          ),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
    PageViewModel(
        title: 'Be more flexible and Secure',
        body:
            "Use this platform in all your device,don't worry about anything.we protect you",
        image: Center(
          child: Lottie.asset('animations/animation_lng60br3.json',
              width: 200, height: 200),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
    PageViewModel(
        title: "Be more mindful spending So, let's get started!",
        body: 'Be mindful spending,and you will be closer to financial freedom',
        image: Center(
          child: Lottie.asset(
            'animations/animation_lng6405y.json',
            width: 350,
            height: 350,
          ),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(15, 15),
            color: Colors.blue,
            activeSize: Size.square(20),
            activeColor: Colors.red,
          ),
          showDoneButton: true,
          done: const Text(
            'Done',
            style: TextStyle(fontSize: 20),
          ),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(fontSize: 20),
          ),
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            size: 25,
          ),
          onDone: () => onDone(context),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  void onDone(context) async {
    //debugPrint('hggg');
    final prefs = await SharedPreferences.getInstance();
    String logged = 'logging';
    await prefs.setString(
      'logged',
      logged,
    );
    //print('worked');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyHome()));
  }
}
