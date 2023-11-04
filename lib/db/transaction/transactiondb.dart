import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_1/calculation/sort.dart';
import 'package:money_1/models/transcation_model.dart';

const transactionDb = 'transaction-db';

abstract class TransactionDbFunction {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> deleteTransaction(int id);
  Future<void> updateTransaction(TransactionModel object);
}

class TransactionDb implements TransactionDbFunction {
  TransactionDb.internal(); //default constructor//common 1

  static TransactionDb instance = TransactionDb.internal(); //assign// c-2

  factory TransactionDb() {
    //fuction//common 3
    return instance;
  }
  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(transactionDb);
    await db.put(obj.id, obj);
    print("index of new transaction ${obj.id}");
    refresh();
  }

  Future<void> refresh() async {
    final list = await getAllTransaction();
    list.sort((first, second) => second.date.compareTo(first.date));

    incomeExpense();
    transactionNotifier.notifyListeners();

    transactionNotifier.value.clear();
    transactionNotifier.value.addAll(list);
    transactionNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    log('inside all transcation fn');
    final db = await Hive.openBox<TransactionModel>(transactionDb);
    final reversedData = db.values.toList().reversed.toList();
    return reversedData;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    print(id);
    log('inside deleteTranscation');
    final db = await Hive.openBox<TransactionModel>(transactionDb);
    db.deleteAt(id);
    log('deleteddd');
    refresh();
  }

  @override
  Future<void> updateTransaction(TransactionModel object) async {
    final db = await Hive.openBox<TransactionModel>(transactionDb);
    print("index of edited transaction ${object.id}");
    await db.put(object.id, object);
  }

  Future<void> clearTransactionDb() async {
    final db = await Hive.openBox<TransactionModel>(transactionDb);
    db.clear();
    refresh();
  }
}
