
// import 'package:flutter/material.dart';

// import 'package:money_1/db/category/categorydb.dart';
// import 'package:money_1/db/transaction/transactiondb.dart';

// import 'package:money_1/models/categorymodel.dart';
// import 'package:money_1/models/transcation_model.dart';
// import 'package:money_1/widgets.dart';

// class MyFloats extends StatefulWidget {
//   const MyFloats({super.key});
//   //final TransactionModel model;
//   // final int id;
//   // final TransactionModel object;

//   @override
//   State<MyFloats> createState() => _MyFloatState();
// }

// class _MyFloatState extends State<MyFloats> {
//   DateTime? selectedDate = DateTime.now();
//   CategoryType? selectedCategorytype;
//   CategoryModel? selectedCategoryModel;
//   int? limit;

//   String? categoryId;
//   //final _formkey = GlobalKey<FormState>();
//   final noteTexteditingController = TextEditingController();
//   final amountTexteditingController = TextEditingController();
//   @override
//   void initState() {
//     CategoryDB.instance.refreshCategoryUi();
//     selectedCategorytype = CategoryType.income;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     CategoryDB.instance.refreshCategoryUi();
//     TransactionDb.instance.refresh();
//     return Scaffold(
//       resizeToAvoidBottomInset: false, //overflow over come
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.teal,
//         title: const Text('Add Transaction '),
//         centerTitle: true,
//         elevation: 0,
//         leading: IconButton(
//             onPressed: () {
//               //RootPage.selectedIndexNotifier.value =0;
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,
//             )),
//       ),
//       body: SafeArea(
//         child: Container(
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color.fromARGB(255, 244, 239, 239), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Column(
//             //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 60),
//                 child: Row(
//                   // mainAxisAlignment: MainAxisAlignment.,
//                   children: [
//                     Radio(
//                       value: CategoryType.income,
//                       groupValue: selectedCategorytype, //category,icon button-2
//                       onChanged: (newvalue) {
//                         setState(() {
//                           //icon button-3
//                           // category = value;
//                           selectedCategorytype = CategoryType.income;
//                           categoryId = null;
//                         });
//                       },
//                     ),
//                     const Text('Income'),
//                     Radio(
//                       value: CategoryType.expense,
//                       groupValue: selectedCategorytype,
//                       onChanged: (newvalue) {
//                         setState(() {
//                           //icon button
//                           //category = value;
//                           selectedCategorytype = CategoryType.expense;
//                           categoryId = null;
//                         });
//                       },
//                     ),
//                     const Text('Expense'),
//                   ],
//                 ),
//               ),
//               DropdownButton(
//                 hint: const Text('Selected Category'),
//                 value: categoryId,

//                 items: (selectedCategorytype == CategoryType.income
//                         ? CategoryDB().incomeCategoryList
//                         : CategoryDB().expenseCategoryList)
//                     .value
//                     .map((e) {
//                   setState(() {
//                     limit = e.limit;
//                   });
//                   return DropdownMenuItem(
//                     value: e.id,
//                     child: Text(e.name),
//                     onTap: () {
//                       print(e.toString()); //check the ontap values
//                       selectedCategoryModel = e;
//                     },
//                   );
//                 }).toList(),

//                 // CategoryDB.instance.icomeCategoryList.value.map((e) {

//                 // }).toList(),

//                 onChanged: (selectedValue) {
//                   print(selectedValue);
//                   setState(() {
//                     categoryId = selectedValue;
//                   });
//                 },
//                 onTap: () {},
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Amount',
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: TextField(
//                         controller: amountTexteditingController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                             border: OutlineInputBorder(), hintText: 'AMOUNT'),
//                       ),
//                     ),
//                     const Text(
//                       'Date',
//                     ),
//                     // selectedDate == null //if condition
//                     Center(
//                         child: TextButton.icon(
//                             onPressed: () async {
//                               final selectedDateIndex = await showDatePicker(
//                                 //time calculation

//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now().subtract(
//                                     const Duration(days: 30)), //years:365
//                                 lastDate: DateTime.now(),
//                               );
//                               if (selectedDateIndex == null) {
//                                 return;
//                               } else {
//                                 print(selectedDate.toString());
//                                 setState(() {
//                                   selectedDate =
//                                       selectedDateIndex; //change widget
//                                 });
//                               }
//                             },
//                             icon: const Icon(Icons.calendar_today_sharp),
//                             //label: Text('Select Date'),
//                             label:
//                                 Text(selectedDate == null //if condition apply
//                                     ? parseDate(DateTime.now())
//                                     : parseDate(selectedDate!)))),
//                     // : Text(selectedDate.toString()), //else condition
//                     const Text(
//                       'Notes',
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: TextField(
//                         controller: noteTexteditingController,
//                         decoration: const InputDecoration(
//                             border: OutlineInputBorder(), hintText: 'Notes'),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal,
//                       ),
//                       onPressed: () {
//                         debugPrint('hello');
//                         editTransaction();
//                         //Navigator.of(context).pop();
//                       },
//                       child: const Center(
//                         child: Text(
//                           'submit',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> editTransaction() async {
//     final purposeText = noteTexteditingController.text.trim();
//     final amountText = amountTexteditingController.text.trim();
//     if (purposeText.isEmpty) {
//       return;
//     }
//     if (amountText.isEmpty) {
//       return;
//     }
//     if (categoryId == null) {
//       return;
//     }
//     if (selectedDate == null) {
//       return;
//     }

//     if (selectedCategoryModel == null) {
//       return;
//     }
//     final parsedAmount = double.tryParse(amountText);
//     if (parsedAmount == null) {
//       return;
//     }

//     final model = TransactionModel(
//         purpose: purposeText,
//         amount: parsedAmount,
//         date: selectedDate!,
//         type: selectedCategorytype!,
//         category: selectedCategoryModel!,
//         limit: limit!,
//         id: DateTime.now().microsecondsSinceEpoch.toString());
//     await TransactionDb.instance.addTransaction(model);
//     debugPrint('success');
//     //add the database in transaction
//     Navigator.of(context).pop();
//     TransactionDb.instance.refresh();
//   }
// }