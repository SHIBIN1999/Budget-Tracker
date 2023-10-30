import 'package:flutter/material.dart';

class MyShare extends StatelessWidget {
  const MyShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Share'),
      ),
      body: SafeArea(
          child: ListTile(
        leading: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text('Share')),
      )),
    );
  }
}
