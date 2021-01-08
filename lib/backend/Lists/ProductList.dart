import 'package:Inhaltsstoff_Warnapp/backend/database/DbTableNames.dart';

import '../database/DbTable.dart';

class ProductList extends DbTable{

  // constructor
  ProductList(int id) : super(id);

  @override
  DbTableNames getTableName() {
    // TODO: implement getTableName
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap({bool withId = true}) {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  static DbTable fromMap(Map<String, dynamic> data) {
    // TODO: implement fromMap
    throw UnimplementedError();
  }

}