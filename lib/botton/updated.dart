import 'package:flutter/material.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';
import 'package:money_1/widgets.dart';

class UpdateTransactionScreen extends StatefulWidget {
  //final int intex;
  final TransactionModel editModel;
  const UpdateTransactionScreen({super.key, required this.editModel});

  @override
  State<UpdateTransactionScreen> createState() =>
      _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  DateTime? selectedDate;
  CategoryType? selectedCategorytype;
  CategoryModel? selectedCategoryModel;

  String? categoryId;
  //final _formkey = GlobalKey<FormState>();
  TextEditingController noteTexteditingController = TextEditingController();
  TextEditingController amountTexteditingController = TextEditingController();
  final limitEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    categoryId = widget.editModel.category.id;
    amountTexteditingController =
        TextEditingController(text: widget.editModel.amount.toString());
    noteTexteditingController =
        TextEditingController(text: widget.editModel.purpose);

    selectedDate = widget.editModel.date;
    selectedCategorytype = widget.editModel.type;
    selectedCategoryModel = widget.editModel.category;
    CategoryDB.instance.refreshCategoryUi();
    TransactionDb.instance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshCategoryUi();
    TransactionDb.instance.refresh();
    return Scaffold(
      resizeToAvoidBottomInset: false, //overflow over come
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text('Edit Transactions'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              //RootPage.selectedIndexNotifier.value =0;
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 244, 239, 239), Colors.grey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Radio(
                    value: CategoryType.income,
                    groupValue: selectedCategorytype, //category,icon button-2
                    onChanged: (newvalue) {
                      setState(() {
                        //icon button-3
                        // category = value;
                        selectedCategorytype = CategoryType.income;
                        categoryId = null;
                      });
                    },
                  ),
                  const Text('Income'),
                  Radio(
                    value: CategoryType.expense,
                    groupValue: selectedCategorytype,
                    onChanged: (newvalue) {
                      setState(() {
                        //icon button
                        //category = value;
                        selectedCategorytype = CategoryType.expense;
                        categoryId = null;
                      });
                    },
                  ),
                  const Text('Expense'),
                ],
              ),
              DropdownButton(
                hint: const Text('Selected Category'),
                value: categoryId,

                items: (selectedCategorytype == CategoryType.income
                        ? CategoryDB().incomeCategoryList
                        : CategoryDB().expenseCategoryList)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      print(e.toString()); //check the ontap values
                      selectedCategoryModel = e;
                    },
                  );
                }).toList(),

                // CategoryDB.instance.icomeCategoryList.value.map((e) {

                // }).toList(),

                onChanged: (selectedValue) {
                  print(selectedValue);
                  setState(() {
                    categoryId = selectedValue;
                  });
                },
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: amountTexteditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: 'AMOUNT'),
                      ),
                    ),
                    const Text(
                      'Date',
                    ),
                    // selectedDate == null //if condition
                    Center(
                        child: TextButton.icon(
                            onPressed: () async {
                              final selectedDateIndex = await showDatePicker(
                                //time calculation

                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                    const Duration(days: 30)), //years:365
                                lastDate: DateTime.now(),
                              );
                              if (selectedDateIndex == null) {
                                return;
                              } else {
                                print(selectedDate.toString());
                                setState(() {
                                  selectedDate =
                                      selectedDateIndex; //change widget
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today_sharp),
                            //label: Text('Select Date'),
                            label:
                                Text(selectedDate == null //if condition apply
                                    ? 'select date'
                                    : parseDate(selectedDate!)))),
                    // : Text(selectedDate.toString()), //else condition
                    const Text(
                      'Notes',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: noteTexteditingController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: 'Notes'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () {
                          editTransactions();
                          CategoryDB.instance.refreshCategoryUi();
                          TransactionDb.instance.refresh();
                          //Navigator.of(context).pop();
                        },
                        child: const Center(
                            child: Text(
                          'submit',
                          style: TextStyle(color: Colors.black),
                        )))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editTransactions() async {
    final purposeText =
        noteTexteditingController.text.trim(); // Fix controller name
    final amountText = amountTexteditingController.text.trim();
    //   final editedLimit = int.parse(limitEditingController.text.trim());
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (categoryId == null) {
      return;
    }
    if (selectedDate == null) {
      return;
    }

    if (selectedCategoryModel == null) {
      return;
    }
    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      purpose: purposeText,
      limit: widget.editModel.limit,
      amount: parsedAmount,
      date: selectedDate!,
      type: selectedCategorytype!,
      category: selectedCategoryModel!,
      id: widget.editModel.id,
    );

    // Add the database in transaction
    TransactionDb.instance.updateTransaction(model);
    Navigator.of(context).pop();
    TransactionDb.instance.refresh();
  }

//   Future<void> editLimit(int newLimit) async {
//     final updatedModel = TransactionModel(
//       purpose: widget.editModel.purpose,
//       limit: limit!, // Set the new limit here
//       amount: widget.editModel.amount,
//       date: widget.editModel.date,
//       type: widget.editModel.type,
//       category: widget.editModel.category,
//       id: widget.editModel.id,
//     );

//     // Update the limit in the database
//     TransactionDb.instance.updateTransaction(updatedModel);

//     // Close the edit limit dialog
//     Navigator.of(context).pop();

//     // Refresh the transaction list
//     TransactionDb.instance.refresh();
//   }
}
