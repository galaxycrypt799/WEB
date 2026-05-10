import '../entities/entities.dart';
import 'models.dart';

class Coffee {
  const Coffee({
    required this.sortOrder,
    required this.coffeeId,
    required this.picture,
    required this.name,
    required this.tagline,
    required this.description,
    required this.category,
    required this.origin,
    required this.roastLevel,
    required this.intensity,
    required this.brewMinutes,
    required this.volumeMl,
    required this.rating,
    required this.price,
    required this.discount,
    required this.tastingNotes,
    required this.macros,
  });

  final int sortOrder;
  final String coffeeId;
  final String picture;
  final String name;
  final String tagline;
  final String description;
  final String category;
  final String origin;
  final String roastLevel;
  final int intensity;
  final int brewMinutes;
  final int volumeMl;
  final double rating;
  final double price;
  final int discount;
  final List<String> tastingNotes;
  final Macros macros;

  double get discountedPrice => price * (100 - discount) / 100;

  Coffee copyWith({
    int? sortOrder,
    String? coffeeId,
    String? picture,
    String? name,
    String? tagline,
    String? description,
    String? category,
    String? origin,
    String? roastLevel,
    int? intensity,
    int? brewMinutes,
    int? volumeMl,
    double? rating,
    double? price,
    int? discount,
    List<String>? tastingNotes,
    Macros? macros,
  }) {
    return Coffee(
      sortOrder: sortOrder ?? this.sortOrder,
      coffeeId: coffeeId ?? this.coffeeId,
      picture: picture ?? this.picture,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      roastLevel: roastLevel ?? this.roastLevel,
      intensity: intensity ?? this.intensity,
      brewMinutes: brewMinutes ?? this.brewMinutes,
      volumeMl: volumeMl ?? this.volumeMl,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      tastingNotes: tastingNotes ?? this.tastingNotes,
      macros: macros ?? this.macros,
    );
  }

  CoffeeEntity toEntity() {
    return CoffeeEntity(
      sortOrder: sortOrder,
      coffeeId: coffeeId,
      picture: picture,
      name: name,
      tagline: tagline,
      description: description,
      category: category,
      origin: origin,
      roastLevel: roastLevel,
      intensity: intensity,
      brewMinutes: brewMinutes,
      volumeMl: volumeMl,
      rating: rating,
      price: price,
      discount: discount,
      tastingNotes: tastingNotes,
      macros: macros,
    );
  }

  static Coffee fromEntity(CoffeeEntity entity) {
    return Coffee(
      sortOrder: entity.sortOrder,
      coffeeId: entity.coffeeId,
      picture: entity.picture,
      name: entity.name,
      tagline: entity.tagline,
      description: entity.description,
      category: entity.category,
      origin: entity.origin,
      roastLevel: entity.roastLevel,
      intensity: entity.intensity,
      brewMinutes: entity.brewMinutes,
      volumeMl: entity.volumeMl,
      rating: entity.rating,
      price: entity.price,
      discount: entity.discount,
      tastingNotes: entity.tastingNotes,
      macros: entity.macros,
    );
  }
}
