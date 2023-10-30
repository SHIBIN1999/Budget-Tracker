import 'package:flutter/material.dart';

class MyAbout extends StatelessWidget {
  const MyAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('About Us'),
          centerTitle: true,
          backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Container(
            height: 220,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(width: 5),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Money Saver',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "   Developed by\n\n   SHAHIR SHIBIN P",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Version 1.1.3',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
