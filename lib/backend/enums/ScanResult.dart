enum ScanResult { Red, Yellow, Green }

extension ScanResultExtension on ScanResult {
  /*
  * return the id that the enum has in the DB
  * defined in assets/database/insert_into_tables_sql.txt
  * */
  int get id {
    switch (this) {
      case ScanResult.Red:
        return 1;
      case ScanResult.Yellow:
        return 2;
      case ScanResult.Green:
        return 3;
      default:
        return null;
    }
  }
}
