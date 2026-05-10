class MacrosEntity {
  const MacrosEntity({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  final int calories;
  final int proteins;
  final int fat;
  final int carbs;

  Map<String, Object?> toDocument() {
    return <String, Object?>{
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
    return MacrosEntity(
      calories: doc['calories'] as int,
      proteins: doc['proteins'] as int,
      fat: doc['fat'] as int,
      carbs: doc['carbs'] as int,
    );
  }
}
