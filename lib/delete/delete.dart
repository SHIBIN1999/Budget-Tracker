import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_1/db/category/categorydb.dart';

alertDeleteCategory(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Do you want to delete this transaction ?'),
        actions: [
          TextButton(
              onPressed: () {
                CategoryDB.instance.deleteCategory(id);
                CategoryDB.instance.incomeCategoryList;
                CategoryDB.instance.expenseCategoryList;
                Navigator.of(context).pop();
                AnimatedSnackBar.rectangle(
                        'Success', 'Category deleted successfully..',
                        type: AnimatedSnackBarType.success,
                        brightness: Brightness.light,
                        duration: const Duration(seconds: 5))
                    .show(
                  context,
                );
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'))
        ],
      );
    },
  );
}
