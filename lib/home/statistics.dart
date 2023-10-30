import 'package:flutter/material.dart';
import 'package:money_1/home/home.dart';
import 'package:money_1/statistics/expenses.dart';
import 'package:money_1/statistics/incomes.dart';
import 'package:money_1/statistics/overview.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const MyHome()));
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Statistics'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'), // Add Tab widgets here
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              MyOverview(),
              IncomeChart(),
              MyExpense(),
            ],
          ),
        ),
      ),
    );
  }
}
