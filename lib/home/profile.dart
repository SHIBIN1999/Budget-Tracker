// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:money_1/Setting/abountus.dart';

import 'package:money_1/Setting/privacy.dart';

import 'package:money_1/Setting/term_condition.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/home/home.dart';
import 'package:money_1/onboarding/onboarding.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({
    super.key,
  });

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Confirmation'),
          content: const Text('Are you sure you want to reset? '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                TransactionDb.instance.clearTransactionDb();
                CategoryDB.instance.clearCategoryDb();
                TransactionDb.instance.refresh();
                CategoryDB.instance.refreshCategoryUi();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => IntroScreen(),
                ));

                // this change
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const MyHome()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyAbout()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PrivacyPolicy()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Team Condition'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TeamsCondition()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reset App'),
              onTap: () {
                _showResetConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
