import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/home/home.dart';
import 'package:money_1/onboarding/onboarding.dart';

// ignore: must_be_immutable
class MySplash extends StatefulWidget {
  MySplash({super.key, this.loggedIn});
  String? loggedIn;
  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void openHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHome()));
  }

  void openIntro() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroScreen()));
  }

  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () async {
        // bool seen = (pref.getBool('seen') ?? false);
        if (widget.loggedIn != null) {
          await TransactionDb.instance.refresh();
          openHome();
        } else {
          openIntro();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 150,
                height: 200,
                child: Image.asset('image/akshaya123.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  gotoIntro() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroScreen()));
  }
}
