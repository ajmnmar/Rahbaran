import 'dart:async';

import 'package:path/path.dart';
import 'package:rahbaran/data_model/setting_model.dart';
import 'package:rahbaran/repository/repository_base.dart';
import 'package:sqflite/sqflite.dart';

class SettingRepository extends RepositoryBase{
  SettingRepository(db):super(db);

  Future<int> save(SettingModel setting) async {
    var result = await db.insert('Setting', setting.toMap());
    return result;
  }

  Future<List<SettingModel>> get() async {
    List<Map<String, dynamic>> maps = await db.query('Setting');

    return List.generate(maps.length, (i) {
      return SettingModel(
        maps[i]['token'],
        maps[i]['refreshtoken'],
      );
    });
  }
}