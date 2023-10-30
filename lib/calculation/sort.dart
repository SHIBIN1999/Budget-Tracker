import 'package:flutter/material.dart';
import 'package:money_1/db/transaction/transactiondb.dart';
import 'package:money_1/models/categorymodel.dart';
import 'package:money_1/models/transcation_model.dart';

ValueNotifier incomeTotal = ValueNotifier(0.0);
ValueNotifier expenseTotal = ValueNotifier(0.0);
ValueNotifier balanceTotal = ValueNotifier(0.0);

incomeExpense() {
  incomeTotal.value = 0;
  expenseTotal.value = 0;
  balanceTotal.value = 0;
  final List<TransactionModel> value =
      TransactionDb.instance.transactionNotifier.value;

  for (int i = 0; i < value.length; i++) {
    if (CategoryType.income == value[i].category.type) {
      incomeTotal.value = incomeTotal.value + value[i].amount;
    } else {
      expenseTotal.value = expenseTotal.value + value[i].amount;
    }
    balanceTotal.value = incomeTotal.value - expenseTotal.value;
  }
}
