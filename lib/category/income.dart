import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_1/db/category/categorydb.dart';
import 'package:money_1/models/categorymodel.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({Key? key})
      : super(key: key); // Corrected constructor syntax

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: CategoryDB().incomeCategoryList,
      builder:
          (BuildContext context, List<CategoryModel> newList, Widget? child) {
        return CategoryDB.instance.incomeCategoryList.value.isEmpty
            ? Center(
                child: Text(
                  'No Category details',
                  style: GoogleFonts.quicksand(),
                ),
              )
            : ListView.separated(
                itemBuilder: (ctx, index) {
                  final category = newList[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 2,
                      right: 8,
                    ),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        title: Text(category.name),
                        // subtitle: Text(category.limit.toString()),
                        trailing: IconButton(
                          onPressed: () async {
                            CategoryDB.instance.deleteCategory(category.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
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
