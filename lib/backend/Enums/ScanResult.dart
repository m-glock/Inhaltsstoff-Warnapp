enum ScanResult { Red, Yellow, Green }

extension ScanResultExtension on ScanResult {
  String get name {
    switch (this) {
      case ScanResult.Red:
        return 'Red';
      case ScanResult.Yellow:
        return 'Yellow';
      case ScanResult.Green:
        return 'Green';
      default:
        return null;
    }
  }

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
