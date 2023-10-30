// import 'package:flutter/material.dart';
// import 'package:money_1/db/category/categorydb.dart';
// import 'package:money_1/db/transaction/transactiondb.dart';
// import 'package:money_1/models/categorymodel.dart';
// import 'package:money_1/models/transcation_model.dart'; //step 4

// ValueNotifier<CategoryType> selectedCategoryNotifier =
//     ValueNotifier(CategoryType.income);
// bool visibility = false;
// Future<void> showCategoryPop(BuildContext context) async {
//   final nameEditingController = TextEditingController();
//   final _limitEdingController = TextEditingController();
//   showDialog(
//       context: context,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setState) => SimpleDialog(
//             title: const Text('Add Category'),
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextFormField(
//                   controller: nameEditingController,
//                   decoration: const InputDecoration(
//                     hintText: 'Category Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: visibility,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     keyboardType: TextInputType.number,
//                     controller: _limitEdingController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Limit',
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       RadioButton(
//                         title: 'Income',
//                         type: CategoryType.income,
//                       ),
//                       RadioButton(title: 'Expense', type: CategoryType.expense),
//                     ],
//                   )),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                     //step 4
//                     onPressed: () {
//                       final _name = nameEditingController.text;
//                       final check = selectedCategoryNotifier.value ==
//                               CategoryType.income
//                           ? CategoryDB.instance.incomeCategoryList.value
//                               .where((element) => element.name.contains(_name))
//                           : CategoryDB.instance.expenseCategoryList.value
//                               .where((element) => element.name.contains(_name));
//                       if (_name.isEmpty) {
//                         return;
//                       }
//                       final _type = selectedCategoryNotifier.value;
//                       final _category = CategoryModel(
//                           limit: selectedCategoryNotifier.value ==
//                                   CategoryType.expense
//                               ? int.parse(_limitEdingController.text)
//                               : 0,
//                           id: DateTime.now().microsecondsSinceEpoch.toString(),
//                           name: _name,
//                           type: _type);
//                       CategoryDB.instance.insertCategory(_category); // step7
//                       Navigator.of(ctx).pop();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     child: const Text(
//                       'Add',
//                     )),
//               ),
//             ],
//           ),
//         );
//       });
// }

// class RadioButton extends StatefulWidget {
//   final String title;
//   final CategoryType type;
//   const RadioButton({
//     super.key,
//     required this.title,
//     required this.type,
//   });

//   @override
//   State<RadioButton> createState() => _RadioButtonState();
// }

// class _RadioButtonState extends State<RadioButton> {
//   // CategoryType? _type;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ValueListenableBuilder(
//           valueListenable: selectedCategoryNotifier,
//           builder: (BuildContext context, CategoryType newCategory, Widget? _) {
//             return Radio<CategoryType>(
//                 value: widget.type,
//                 groupValue: selectedCategoryNotifier.value, //_type,
//                 onChanged: (value) {
//                   if (value == null) {
//                     return;
//                   }
//                   selectedCategoryNotifier.value = value;
//                   selectedCategoryNotifier.notifyListeners();
//                 });
//           },
//         ),
//         Text(widget.title), // stateless anakil nera text(title),
//       ],
//     );
//   }
// }

// Future<void> showEditLimitPop(
//     BuildContext context, TransactionModel limitModel) async {
//   final limitEditingController =
//       TextEditingController(); // Use a TextEditingController for the limit field

//   showDialog(
//     context: context,
//     builder: (ctx) {
//       return SimpleDialog(
//         title: const Text('Edit Category Limit'),
//         children: [
//           // Add a TextFormField for editing the limit
//           TextFormField(
//             keyboardType: TextInputType.number,
//             controller: limitEditingController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Limit',
//             ),
//           ),

//           ElevatedButton(
//             onPressed: () async {
//               // Get the new limit value from the _limitEditingController
//               final newLimit = int.tryParse(limitEditingController.text);
//               if (newLimit != null) {
//                 await TransactionDb.instance.updateTransaction(TransactionModel(
//                     purpose: limitModel.purpose,
//                     amount: limitModel.amount,
//                     date: limitModel.date,
//                     type: limitModel.type,
//                     category: limitModel.category,
//                     id: limitModel.id,
//                     limit: newLimit));

//                 Navigator.of(context).pop();
//                 TransactionDb.instance.refresh();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//             ),
//             child: const Text('Save'),
//           ),
//         ],
//       );
//     },
//   );
// }

// class CategoryDialog extends StatefulWidget {
//   @override
//   _CategoryDialogState createState() => _CategoryDialogState();
// }

// class _CategoryDialogState extends State<CategoryDialog> {
//   final nameEditingController = TextEditingController();
//   final _limitEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       title: const Text('Add Category'),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: TextFormField(
//             controller: nameEditingController,
//             decoration: const InputDecoration(
//               hintText: 'Category Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         selectedCategoryNotifier.value == CategoryType.income
//             ? SizedBox()
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   controller: _limitEditingController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Limit',
//                   ),
//                 ),
//               ),
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               RadioButton(
//                 title: 'Income',
//                 type: CategoryType.income,
//               ),
//               RadioButton(title: 'Expense', type: CategoryType.expense),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton(
//               //step 4
//               onPressed: () {
//                 final _name = nameEditingController.text;
//                 final check =
//                     selectedCategoryNotifier.value == CategoryType.income
//                         ? CategoryDB.instance.incomeCategoryList.value
//                             .where((element) => element.name.contains(_name))
//                         : CategoryDB.instance.expenseCategoryList.value
//                             .where((element) => element.name.contains(_name));
//                 if (_name.isEmpty) {
//                   return;
//                 }
//                 final _type = selectedCategoryNotifier.value;
//                 final _category = CategoryModel(
//                     limit:
//                         selectedCategoryNotifier.value == CategoryType.expense
//                             ? int.parse(_limitEditingController.text)
//                             : 0,
//                     id: DateTime.now().microsecondsSinceEpoch.toString(),
//                     name: _name,
//                     type: _type);
//                 CategoryDB.instance.insertCategory(_category); // step7
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//               child: const Text(
//                 'Add',
//               )),
//         ),
//       ],
//     );
//   }
// }

// // Update your showDialog to use CategoryDialog
// Future<void> showCategoryPopup(BuildContext context) async {
//   showDialog(
//     context: context,
//     builder: (ctx) {
//       return CategoryDialog();
//     },
//   );
// }
