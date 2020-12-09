import 'package:Inhaltsstoff_Warnapp/backend/database/DbTable.dart';
import 'package:Inhaltsstoff_Warnapp/backend/database/DbTableNames.dart';

class Product extends DbTable{

  Product(int id) : super(id);

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

}