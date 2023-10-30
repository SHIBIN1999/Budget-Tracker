import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_1/models/categorymodel.dart';

const CATEGORY_DB_NAME = 'category-database'; //step 3

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String CategoryID);
  // Future<void> editCategory(CategoryModel updatedCategory);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal(); //object//singletone

  static CategoryDB instance = CategoryDB._internal(); //veriable

  factory CategoryDB() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  get incomeCategoryListListener => null;

  get expenseCategoryListListener => null;

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);

    refreshCategoryUi();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> refreshCategoryUi() async {
    final allCAtegories = await getCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();

    await Future.forEach(
      allCAtegories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.value.add(category);
        } else {
          expenseCategoryList.value.add(category);
        }
      },
    );
    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    try {
      await categoryDB.delete(categoryID);
    } catch (e) {
      log('cannot delete');
    }
    refreshCategoryUi();
  }

  Future<void> clearCategoryDb() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.clear();
    refreshCategoryUi();
  }
}
