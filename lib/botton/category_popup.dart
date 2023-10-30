import 'package:flutter/material.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/models/categorymodel.dart';

class CategoryPopup extends StatefulWidget {
  const CategoryPopup({super.key});

  @override
  State<CategoryPopup> createState() => _CategoryPopupState();
}

class _CategoryPopupState extends State<CategoryPopup> {
  bool showLimitField = false;
  final nameEditingController = TextEditingController();
  final limitEditingController = TextEditingController();

  CategoryType selectedCategory = CategoryType.income;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: nameEditingController,
            decoration: const InputDecoration(
              hintText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Radio<CategoryType>(
                value: CategoryType.income,
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    showLimitField = false;
                  });
                },
              ),
              Text('Income'),
              Radio<CategoryType>(
                value: CategoryType.expense,
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    showLimitField = true;
                  });
                },
              ),
              Text('Expense'),
            ],
          ),
        ),
        Visibility(
          visible: showLimitField,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: limitEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Limit',
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameEditingController.text;
            if (name.isEmpty) {
              return;
            }
            final type = selectedCategory;
            final limit = type == CategoryType.expense
                ? int.tryParse(limitEditingController.text) ?? 0
                : 0;

            final category = CategoryModel(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: name,
              type: type,
              limit: limit,
            );

            CategoryDB.instance.insertCategory(category);
            Navigator.of(context).pop();
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
