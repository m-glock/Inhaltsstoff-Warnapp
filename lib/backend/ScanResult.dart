enum ScanResult { Red, Yellow, Green }

extension ScanResultExtension on ScanResult {
  String get name {
    switch (this) {
      case ScanResult.Red:
        return 'red';
      case ScanResult.Yellow:
        return 'yellow';
      case ScanResult.Green:
        return 'green';
      default:
        return null;
    }
  }
}
