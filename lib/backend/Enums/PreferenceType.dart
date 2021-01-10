enum PreferenceType { None, NotWanted, NotPreferred, Preferred }

extension PreferenceTypeExtension on PreferenceType {
  String get name {
    switch (this) {
      case PreferenceType.None:
        return 'None';
      case PreferenceType.NotWanted:
        return 'Not Wanted';
      case PreferenceType.NotPreferred:
        return 'Not Preferred';
      case PreferenceType.Preferred:
        return 'Preferred';
      default:
        return null;
    }
  }
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
