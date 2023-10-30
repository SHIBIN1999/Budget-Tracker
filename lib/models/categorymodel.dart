import 'package:hive/hive.dart';
//step 1
part 'categorymodel.g.dart';

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final bool isDelete;
  @HiveField(3)
  CategoryType type;
  @HiveField(4)
  int limit;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.isDelete = false,
    required this.limit,
  });

  @override
  String toString() {
    return '$name $type';
  }
}
