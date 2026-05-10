import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String coffeeId;
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.coffeeId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'coffeeId': coffeeId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    return OrderItem(
      coffeeId: map['coffeeId'] as String? ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [coffeeId, name, quantity, price];
}
