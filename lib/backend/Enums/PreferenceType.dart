enum PreferenceType { None, NotWanted, NotPreferred, Preferred }

extension PreferenceTypeExtension on PreferenceType {
  String get name {
    switch (this) {
      case PreferenceType.NotWanted:
        return 'notwanted';
      case PreferenceType.NotPreferred:
        return 'notpreferred';
      case PreferenceType.Preferred:
        return 'preferred';
      case PreferenceType.None:
        return 'none';
      default:
        return null;
    }
  }

  /*
  * return the id that the enum has in the DB
  * defined in assets/database/insert_into_tables_sql.txt
  * */
  int get id {
    switch (this) {
      case PreferenceType.None:
        return 1;
      case PreferenceType.NotWanted:
        return 2;
      case PreferenceType.NotPreferred:
        return 3;
      case PreferenceType.Preferred:
        return 4;
      default:
        return null;
    }
  }
}
