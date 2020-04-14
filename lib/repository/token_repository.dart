import 'dart:async';

import 'package:path/path.dart';
import 'package:rahbaran/data_model/token_model.dart';
import 'package:rahbaran/repository/repository_base.dart';
import 'package:sqflite/sqflite.dart';

class TokenRepository extends RepositoryBase{
  TokenRepository(db):super(db);

  Future<int> save(TokenModel token) async {
    var result = await db.insert('Token', token.toMap());
    return result;
  }

  Future<List<TokenModel>> get() async {
    List<Map<String, dynamic>> maps = await db.query('Token');

    return List.generate(maps.length, (i) {
      return TokenModel(
        maps[i]['token'],
        maps[i]['refreshtoken'],
      );
    });
  }

  Future<int> deleteAll() async{
    var result= db.delete('Token');
    return result;
  }


}