import 'dart:developer';
import 'dart:ffi';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:money_1/botton/floating.dart';
import 'package:money_1/botton/updated.dart';
import 'package:money_1/calculation/sort.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/home/profile.dart';
import 'package:money_1/home/statistics.dart';
import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';

import 'package:money_1/widgets.dart';
import 'package:money_1/widgets/custom_container_widget.dart';
import 'package:money_1/widgetseeall/seeall.dart';

import 'category_main.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
  }) : super(key: key);
  static final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  var _currentindex = 0;
  late List<Widget> _page = [];

  @override
  void initState() {
    super.initState();
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshCategoryUi();
    _page = [
      const HomeScreens(),
      const Statistics(),
      const MyCategory(),
      const Myprofile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshCategoryUi();
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        //valueListenable: selectedIndexNotifier,
        valueListenable: MyHome.selectedIndexNotifier,
        builder: (BuildContext ctx, int updatedindex, Widget? _) {
          return _page[_currentindex];
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.black,
        currentIndex: _currentindex,
        onTap: (int index) {
          setState(() {
            _currentindex = index;
            log(_currentindex
                .toString()); // Update the current index when a tab is tapped
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Statistic',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Category',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

//HomeScreen
class HomeScreens extends StatefulWidget {
  const HomeScreens({
    super.key,
  });

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  @override
  void initState() {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshCategoryUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshCategoryUi();

    return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 205, 207, 209),
                  Color.fromARGB(255, 235, 228, 228)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 310,
                  child: _head(), // Full total balance box
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction History',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () {
                          MyHome.selectedIndexNotifier.value = 3;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MySeeAll(),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color.fromARGB(255, 18, 18, 18),
                          ),
                        ),
                      ),

                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.teal),
                      //   onPressed: () {
                      //     MyHome.selectedIndexNotifier.value = 3;
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => const MySeeAll(),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text(
                      //     'See All',
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 16,
                      //       color: Color.fromARGB(255, 18, 18, 18),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Replace this part with your transaction history list
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable:
                        Hive.box<TransactionModel>(transactionDb).listenable(),
                    //TransactionDb.instance.transactionNotifier,
                    builder: (BuildContext ctx, Box<TransactionModel> newList,
                        Widget? _) {
                      return Hive.box<TransactionModel>(transactionDb).isEmpty
                          ? const Center(
                              child: Text("No Transaction Found"),
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                final transactions =
                                    newList.values.toList()[index];
                                return Slidable(
                                  key: Key(transactions.id!),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          log('onpress id ${transactions.id}',
                                              name: 'Slidable');
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Do you want to delete this transaction ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      TransactionDb.instance
                                                          .deleteTransaction(
                                                              index);
                                                      TransactionDb.instance
                                                          .refresh();
                                                      Navigator.of(context)
                                                          .pop();
                                                      AnimatedSnackBar
                                                          .rectangle(
                                                        'Success',
                                                        'Transaction deleted successfully..',
                                                        type:
                                                            AnimatedSnackBarType
                                                                .success,
                                                        brightness:
                                                            Brightness.light,
                                                        duration:
                                                            const Duration(
                                                          seconds: 5,
                                                        ),
                                                      ).show(
                                                        context,
                                                      );
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('No'),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: Colors.red,
                                        label: 'delete',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          print(
                                            'onpress id ${transactions.id}',
                                          );
                                          //edit funtion
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateTransactionScreen(
                                                editModel: transactions,
                                                // intex: index,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icons.edit,
                                        backgroundColor: Colors.green,
                                        label: 'edit',
                                      )
                                    ],
                                  ),
                                  child: CustomContainer(
                                    child: ListTile(
                                      //
                                      leading: Icon(
                                        transactions.type == CategoryType.income
                                            ? Icons.arrow_circle_up_outlined
                                            : Icons.arrow_circle_down_sharp,
                                        size: 45,
                                        color: transactions.type ==
                                                CategoryType.income
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      title: Text(
                                        transactions.category.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transactions.type ==
                                                    CategoryType.income
                                                ? 'Amount: ₹${transactions.amount}'
                                                : 'Spend: ₹${transactions.amount}',
                                          ),
                                          if (transactions.type !=
                                              CategoryType.income)
                                            Text(
                                                'Limit: ₹${transactions.limit}'),
                                          if (transactions.type !=
                                              CategoryType.income)
                                            Text(transactions.limit >
                                                    transactions.amount
                                                ? 'Remaining:₹${transactions.limit - transactions.amount}'
                                                : 'Remaining:₹0.00'),
                                        ],
                                      ),
                                      trailing:
                                          Text(parseDate(transactions.date)),
                                    ),
                                  ),

                                  // child: Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Icon(
                                  //       transactions.type ==
                                  //               CategoryType.income
                                  //           ? Icons
                                  //               .arrow_circle_up_outlined
                                  //           : Icons
                                  //               .arrow_circle_down_sharp,
                                  //       size: 45,
                                  //       color: transactions.type ==
                                  //               CategoryType.income
                                  //           ? Colors.green
                                  //           : Colors.red,
                                  //     ),

                                  //     //////
                                  //     ///

                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           transactions.category.name,
                                  //           style: const TextStyle(
                                  //               fontWeight:
                                  //                   FontWeight.bold,
                                  //               fontSize: 16),
                                  //         ),
                                  //         transactions.type ==
                                  //                 CategoryType.income
                                  //             ? Text(
                                  //                 'Amount:  ₹${transactions.amount}')
                                  //             : Text(
                                  //                 'Spend:  ₹${transactions.amount}'),
                                  //         transactions.type ==
                                  //                 CategoryType.income
                                  //             ? const SizedBox()
                                  //             : Text(
                                  //                 'Limit:  ₹${transactions.limit}'),
                                  //         transactions.type ==
                                  //                 CategoryType.income
                                  //             ? const SizedBox()
                                  //             : Text(transactions.limit >
                                  //                     transactions.amount
                                  //                 ? 'Remainig:  ₹${transactions.limit - transactions.amount}'
                                  //                 : 'Remainig:  ₹0.00'),
                                  //       ],
                                  //     ),
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.end,
                                  //       children: [
                                  //         const SizedBox(
                                  //           height: 5,
                                  //         ),
                                  //         SizedBox(
                                  //           height: 10,
                                  //         ),
                                  //         Text(parseDate(
                                  //             transactions.date)),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 12);
                              },
                              itemCount:
                                  newList.length > 2 ? 2 : newList.length);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            TransactionDb.instance.refresh();
            CategoryDB.instance.refreshCategoryUi();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => const MyFloats()));
          },
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}

Widget _head() {
  TransactionDb.instance.refresh();
  CategoryDB.instance.refreshCategoryUi();
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              color: Colors.teal,
              // gradient:
              //  LinearGradient(colors: [Colors.green, Colors.orange]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 310,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 19, 2, 2)),
                      ),
                      Text(
                        'Akshaya Center',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 120,
        left: 30,
        right: 30,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 185,
          width: 320,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 222, 218, 214),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: balanceTotal,
                builder: (context, value, child) {
                  var tbalance = value;
                  return Text(
                    '₹ $tbalance',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 85, 145, 141),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 15, 15, 15),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ValueListenableBuilder(
                              valueListenable: incomeTotal,
                              builder: (context, value, child) {
                                return Text(
                                  // Display Total Income
                                  '₹ $value',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 85, 145, 141),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Expanses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 15, 15, 15),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ValueListenableBuilder(
                              valueListenable: expenseTotal,
                              builder: (context, value, child) {
                                return Text(
                                  // Display Total Income
                                  '₹ $value',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      )
    ],
  );
}
