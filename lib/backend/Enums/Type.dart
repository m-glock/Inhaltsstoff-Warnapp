
enum Type { Allergen, Nutriment, General}

extension TypeExtension on Type {
  String get name {
    switch (this) {
      case Type.Allergen:
        return 'Allergen';
      case Type.Nutriment:
        return 'Nutriment';
      case Type.General:
        return 'General';
      default:
        return null;
    }
  }
}