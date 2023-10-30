import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/models/categorymodel.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override //step 5
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryList,
      builder: (BuildContext context, List<CategoryModel> newList, Widget? _) {
        return CategoryDB.instance.expenseCategoryList.value.isEmpty
            ? Center(
                child: Text(
                  'No category details',
                  style: GoogleFonts.quicksand(),
                ),
              )
            : ListView.separated(
                itemBuilder: (ctx, index) {
                  final category = newList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, top: 2, right: 8),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                          title: Text(category.name),
                          subtitle: Text(category.limit.toString()),
                          trailing: IconButton(
                              onPressed: () {
                                CategoryDB.instance.deleteCategory(category.id);
                              },
                              icon: const Icon(Icons.delete))),
                    ),
                  );
                },
                separatorBuilder: (ctx, Index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: newList.length,
              );
      },
    );
  }
}
