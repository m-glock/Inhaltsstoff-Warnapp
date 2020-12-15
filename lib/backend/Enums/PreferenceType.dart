enum PreferenceType { NotWanted, NotPreferred, Preferred, None }

extension PreferenceTypeExtension on PreferenceType {
  int get name {
    switch (this) {
      case PreferenceType.NotWanted:
        return 1;//'notwanted';
      case PreferenceType.NotPreferred:
        return 2;//'notpreferred';
      case PreferenceType.Preferred:
        return 3;//'preferred';
      case PreferenceType.None:
        return 4;//'none';
      default:
        return null;
    }
  }
}
