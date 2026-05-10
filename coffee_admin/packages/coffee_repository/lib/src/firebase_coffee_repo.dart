import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCoffeeRepo implements CoffeeRepo {
  FirebaseCoffeeRepo({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    this.seedIfEmpty = true,
  }) : _coffeeCollection =
            (firestore ?? FirebaseFirestore.instance).collection('coffees'),
       _storage = storage ?? FirebaseStorage.instance;

  final CollectionReference<Map<String, dynamic>> _coffeeCollection;
  final FirebaseStorage _storage;
  final bool seedIfEmpty;

  @override
  Future<List<Coffee>> getCoffees() async {
    try {
      var snapshot = await _coffeeCollection.orderBy('sortOrder').get();

      if (snapshot.docs.isEmpty && seedIfEmpty) {
        await _seedCollection();
        snapshot = await _coffeeCollection.orderBy('sortOrder').get();
      }

      if (snapshot.docs.isEmpty) {
        return LocalCoffeeRepo.bundledMenu;
      }

      return snapshot.docs
          .map(
              (doc) => Coffee.fromEntity(CoffeeEntity.fromDocument(doc.data())))
          .toList(growable: false);
    } catch (error, stackTrace) {
      log(
        'Loading coffees from Firebase failed, returning bundled menu instead.',
        error: error,
        stackTrace: stackTrace,
      );
      return LocalCoffeeRepo.bundledMenu;
    }
  }

  @override
  Future<void> createCoffee(Coffee coffee) async {
    final normalizedCoffee = _normalizeCoffee(coffee);
    await _coffeeCollection
        .doc(normalizedCoffee.coffeeId)
        .set(normalizedCoffee.toEntity().toDocument());
  }

  @override
  Future<String> uploadCoffeeImage(Uint8List file, String fileName) async {
    final safeName = _sanitizeFileName(fileName);
    final reference = _storage
        .ref()
        .child('coffee_images')
        .child('${DateTime.now().millisecondsSinceEpoch}_$safeName');

    await reference.putData(
      file,
      SettableMetadata(
        contentType: _guessContentType(fileName),
      ),
    );
    return reference.getDownloadURL();
  }

  Future<void> _seedCollection() async {
    final batch = _coffeeCollection.firestore.batch();

    for (final coffee in LocalCoffeeRepo.bundledMenu) {
      batch.set(_coffeeCollection.doc(coffee.coffeeId),
          coffee.toEntity().toDocument());
    }

    await batch.commit();
  }

  Coffee _normalizeCoffee(Coffee coffee) {
    final generatedId = coffee.coffeeId.trim().isNotEmpty
        ? coffee.coffeeId.trim()
        : '${_slugify(coffee.name)}-${DateTime.now().millisecondsSinceEpoch}';

    return coffee.copyWith(
      coffeeId: generatedId,
      sortOrder: coffee.sortOrder > 0
          ? coffee.sortOrder
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _slugify(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return normalized.isEmpty ? 'coffee' : normalized;
  }

  String _sanitizeFileName(String value) {
    final sanitized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9._-]+'), '-');
    return sanitized.isEmpty ? 'coffee.jpg' : sanitized;
  }

  String _guessContentType(String fileName) {
    final lowerCase = fileName.toLowerCase();
    if (lowerCase.endsWith('.png')) {
      return 'image/png';
    }
    if (lowerCase.endsWith('.webp')) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }
}
