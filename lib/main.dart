import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';

import 'package:money_1/screen/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  //step2
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedIn = prefs.getString('logged');
  log(loggedIn.toString());
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(MyApp(
    loggedIn: loggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final String? loggedIn;
  const MyApp({super.key, this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My New Project',
      debugShowCheckedModeBanner: false,
      home: MySplash(loggedIn: loggedIn),
      //MyScreen(),
    );
  }
}
