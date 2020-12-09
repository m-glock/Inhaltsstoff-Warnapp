enum PreferenceType { NotWanted, NotPreferred, Preferred, None }

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
}
