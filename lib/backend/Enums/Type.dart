enum Type { Allergen, Nutriment, General}

extension TypeExtension on Type {
  /*
  * return the id that the enum has in the DB
  * defined in assets/database/insert_into_tables_sql.txt
  * */
  int get id {
    switch (this) {
      case Type.Allergen:
        return 1;
      case Type.Nutriment:
        return 2;
      case Type.General:
        return 3;
      default:
        return null;
    }
  }
}