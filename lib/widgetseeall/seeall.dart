import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

import 'package:money_1/botton/floating.dart';
import 'package:money_1/botton/updated.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';
import 'package:money_1/widgets.dart';

import 'package:money_1/widgets/custom_container_widget.dart';

class MySeeAll extends StatefulWidget {
  const MySeeAll({super.key});

  @override
  State<MySeeAll> createState() => _MySeeAllState();
}

class _MySeeAllState extends State<MySeeAll> {
  List<TransactionModel> newList = [];
  String selectedCategoryFilter = 'All';
  String selectedDateFilter = 'All';
  String searchText = '';
  DateTime? startDate;
  DateTime? endDate;
  List<TransactionModel> filteredList = [];
  @override
  void initState() {
    super.initState();
    //newList = fetchTransactions();
    TransactionDb.instance.refresh();
    CategoryDB.instance.refreshCategoryUi();
  }

  List<TransactionModel> filterTransactionsByDateRange(
      List<TransactionModel> transactions) {
    if (startDate == null || endDate == null) {
      return transactions;
    }

    return transactions.where((transaction) {
      return transaction.date.isAtSameMomentAs(startDate!) ||
          (transaction.date.isAfter(startDate!) &&
              transaction.date.isBefore(endDate!.add(const Duration(days: 1))));
    }).toList();
  }

  void updateFilteredList(List<TransactionModel> newList) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredList = newList.reversed.where((transaction) {
          bool categoryMatch = selectedCategoryFilter == 'All' ||
              (selectedCategoryFilter == 'Income' &&
                  transaction.type == CategoryType.income) ||
              (selectedCategoryFilter == 'Expense' &&
                  transaction.type == CategoryType.expense);

          bool dateMatch = selectedDateFilter == 'All' ||
              (selectedDateFilter == 'Today' && isToday(transaction.date)) ||
              (selectedDateFilter == 'Yesterday' &&
                  isYesterday(transaction.date)) ||
              (selectedDateFilter == 'Last Week' &&
                  isLastWeek(transaction.date)) ||
              (selectedDateFilter == 'Month' && isThisMonth(transaction.date));

          bool textMatch = searchText.isEmpty ||
              transaction.category.name
                  .toLowerCase()
                  .contains(searchText.toLowerCase());

          return categoryMatch && dateMatch && textMatch; //remove dateMatch
        }).toList();
        if (startDate != null && endDate != null) {
          //including new in time filler
          filteredList = filterTransactionsByDateRange(filteredList);
        }
      });
    });
  }

  // List<TransactionModel> filterTransactionsByDateRange(
  //     List<TransactionModel> transactions) {
  //   if (startDate == null || endDate == null) {
  //     return transactions;
  //   }

  //   return transactions.where((transaction) {
  //     return transaction.date.isAtSameMomentAs(startDate!) ||
  //         (transaction.date.isAfter(startDate!) &&
  //             transaction.date.isBefore(endDate!.add(const Duration(days: 1))));
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    //CategoryDB.instance.refreshCategoryUi();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        // Filter transactions based on selected category and date filters
        updateFilteredList(newList);
        //showDateRangePicker();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: const Text('All Transaction'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: PopupMenuButton(
                  onSelected: (String filter) {
                    setState(() {
                      selectedCategoryFilter = filter;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'All',
                      child: Row(
                        children: [
                          Text('All'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Income',
                      child: Row(
                        children: [
                          Text('Income'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Expense',
                      child: Row(
                        children: [
                          Text('Expense'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.filter_list,
                    size: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: PopupMenuButton(
                  onSelected: (String filter) {
                    setState(() {
                      selectedDateFilter = filter;
                      if (filter != 'All') {
                        //including 3 comments
                        startDate = null;
                        endDate = null;
                      }
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'All',
                      child: Row(
                        children: [
                          Text('All'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Today',
                      child: Row(
                        children: [
                          Text('Today'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Yesterday',
                      child: Row(
                        children: [
                          Text('Yesterday'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Last Week',
                      child: Row(
                        children: [
                          Text('Last Week'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Month',
                      child: Row(
                        children: [
                          Text('Month'),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_horiz,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: CupertinoSearchTextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),

              // Date Filter

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showCustomDateRangePicker(
                        context,
                        dismissible: true,
                        primaryColor: Colors.grey,
                        backgroundColor: Colors.black,
                        minimumDate: DateTime(2010),
                        maximumDate: DateTime.now(),
                        onApplyClick: (start, end) {
                          setState(() {
                            startDate = start;
                            endDate = end;
                            selectedDateFilter = 'All';
                          });

                          // Filter transactions by date range
                          //  updateFilteredList(newList);
                        },
                        onCancelClick: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });

                          // Remove date range filter
                          // updateFilteredList(newList);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: startDate == null
                        ? const Row(
                            children: [
                              Icon(Icons.calendar_month),
                              Text('Select Date range')
                            ],
                          )
                        : Text(
                            '${startDate != null ? DateFormat("dd/MMM/yyyy").format(startDate!) : '-'} - ${endDate != null ? DateFormat("dd/MMM/yyyy").format(endDate!) : '-'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              filteredList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Text('No transaction found'),
                    )
                  : Expanded(
                      child: ListView.separated(
                          itemBuilder: (ctx, index) {
                            final transaction = filteredList[index];

                            return Slidable(
                                key: Key(transaction.id!),
                                startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
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
                                                      AnimatedSnackBar.rectangle(
                                                              'Success',
                                                              'Transaction deleted successfully..',
                                                              type:
                                                                  AnimatedSnackBarType
                                                                      .success,
                                                              brightness:
                                                                  Brightness
                                                                      .light,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          5))
                                                          .show(
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
                                          //edit funtion
                                          print('onpress id ${transaction.id}');
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateTransactionScreen(
                                              editModel: transaction,
                                              // intex: index,
                                            ),
                                          ));
                                        },
                                        icon: Icons.edit,
                                        backgroundColor: Colors.green,
                                        label: 'edit',
                                      )
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(index);
                                    },
                                    child: CustomContainer(
                                      child: ListTile(
                                        //
                                        leading: Icon(
                                          transaction.type ==
                                                  CategoryType.income
                                              ? Icons.arrow_circle_up_outlined
                                              : Icons.arrow_circle_down_sharp,
                                          size: 45,
                                          color: transaction.type ==
                                                  CategoryType.income
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        title: Text(
                                          transaction.category.name,
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
                                              transaction.type ==
                                                      CategoryType.income
                                                  ? 'Amount: ₹${transaction.amount}'
                                                  : 'Spend: ₹${transaction.amount}',
                                            ),
                                            if (transaction.type !=
                                                CategoryType.income)
                                              Text(
                                                  'Limit: ₹${transaction.limit}'),
                                            if (transaction.type !=
                                                CategoryType.income)
                                              Text(transaction.limit >
                                                      transaction.amount
                                                  ? 'Remaining:₹${transaction.limit - transaction.amount}'
                                                  : 'Remaining:₹0.00'),
                                          ],
                                        ),
                                        trailing:
                                            Text(parseDate(transaction.date)),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12);
                          },
                          itemCount: filteredList.length)) // newList.length
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            onPressed: () {
              TransactionDb.instance.refresh();
              CategoryDB.instance.refreshCategoryUi();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const MyFloats()));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  bool isLastWeek(DateTime date) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    return date.isAfter(lastWeek);
  }

  bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}
//part 2

