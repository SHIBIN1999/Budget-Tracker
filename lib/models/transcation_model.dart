import 'package:hive_flutter/adapters.dart';
import 'package:money_1/models/categorymodel.dart';
part 'transcation_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String purpose;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final CategoryModel category;
  @HiveField(5)
  String? id;
  @HiveField(6)
  int limit;

  TransactionModel({
    required this.purpose,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.id,
    required this.limit,
  }) {
    // id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
