import 'package:coffee_repository/src/entities/macros_entity.dart';

import '../models/models.dart';

class CoffeeEntity {
  const CoffeeEntity({
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

  Map<String, Object?> toDocument() {
    return <String, Object?>{
      'sortOrder': sortOrder,
      'coffeeId': coffeeId,
      'picture': picture,
      'name': name,
      'tagline': tagline,
      'description': description,
      'category': category,
      'origin': origin,
      'roastLevel': roastLevel,
      'intensity': intensity,
      'brewMinutes': brewMinutes,
      'volumeMl': volumeMl,
      'rating': rating,
      'price': price,
      'discount': discount,
      'tastingNotes': tastingNotes,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static CoffeeEntity fromDocument(Map<String, dynamic> doc) {
    return CoffeeEntity(
      sortOrder: doc['sortOrder'] as int? ?? 0,
      coffeeId: doc['coffeeId'] as String,
      picture: doc['picture'] as String,
      name: doc['name'] as String,
      tagline: doc['tagline'] as String,
      description: doc['description'] as String,
      category: doc['category'] as String,
      origin: doc['origin'] as String,
      roastLevel: doc['roastLevel'] as String,
      intensity: doc['intensity'] as int,
      brewMinutes: doc['brewMinutes'] as int,
      volumeMl: doc['volumeMl'] as int,
      rating: (doc['rating'] as num).toDouble(),
      price: (doc['price'] as num).toDouble(),
      discount: doc['discount'] as int,
      tastingNotes: List<String>.from(doc['tastingNotes'] as List<dynamic>),
      macros: Macros.fromEntity(
        MacrosEntity.fromDocument(doc['macros'] as Map<String, dynamic>),
      ),
    );
  }
}
