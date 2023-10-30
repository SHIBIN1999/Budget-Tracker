import 'package:flutter/material.dart';
import 'package:money_1/botton/category_popup.dart';
import 'package:money_1/botton/categorypop.dart';
import 'package:money_1/category/expense.dart';
import 'package:money_1/category/income.dart';

import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/home/home.dart';

class MyCategory extends StatefulWidget {
  const MyCategory({super.key});

  @override
  State<MyCategory> createState() => _MyCategoryState();
}

class _MyCategoryState extends State<MyCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    // CategoryDB().getCategories().then((value) {
    //   print('Categories get');
    //   print(value.toString());
    // });
    CategoryDB().refreshCategoryUi();
    super.initState();
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
        title: const Text('Category'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.teal,
                tabs: const [
                  Tab(
                    text: 'Income',
                  ),
                  Tab(
                    text: 'Expense',
                  )
                ]),
            Expanded(
              child: TabBarView(controller: _tabController, children: const [
                // Text('income list here'),
                // Text('Expense list here'),
                IncomeList(),
                ExpenseList(),
              ]),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CategoryPopup();
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
