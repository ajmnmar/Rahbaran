import 'package:sqflite/sqflite.dart';

abstract class RepositoryBase{
  final Database db;
  RepositoryBase(this.db);
}