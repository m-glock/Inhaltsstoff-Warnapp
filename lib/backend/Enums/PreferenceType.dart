enum PreferenceType { NotWanted, NotPreferred, Preferred, None }

extension PreferenceTypeExtension on PreferenceType {
  String get name {
    switch (this) {
      case PreferenceType.NotWanted:
        return 'Not Wanted';
      case PreferenceType.NotPreferred:
        return 'Not Preferred';
      case PreferenceType.Preferred:
        return 'Preferred';
      case PreferenceType.None:
        return 'None';
      default:
        return null;
    }
  }
}
