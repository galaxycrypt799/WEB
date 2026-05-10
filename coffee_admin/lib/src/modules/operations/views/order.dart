import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_item.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? notes;

  const Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveryAddress,
    this.notes,
  });

  static Order empty = Order(
    id: '',
    userId: '',
    customerName: '',
    customerPhone: '',
    customerEmail: '',
    items: const [],
    totalPrice: 0,
    status: 'pending',
    paymentMethod: 'cash',
    createdAt: DateTime.now(),
  );

  Order copyWith({
    String? id,
    String? userId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<OrderItem>? items,
    double? totalPrice,
    String? status,
    String? paymentMethod,
    DateTime? createdAt,
    String? deliveryAddress,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'orderId': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  static Order fromDocument(Map<String, dynamic> doc) {
    final rawCreatedAt = doc['createdAt'];
    final parsedCreatedAt = rawCreatedAt is Timestamp
        ? rawCreatedAt.toDate()
        : DateTime.tryParse(rawCreatedAt?.toString() ?? '') ?? DateTime.now();

    return Order(
      id: doc['id'] as String? ?? doc['orderId'] as String? ?? '',
      userId: doc['userId'] as String? ?? '',
      customerName: doc['customerName'] as String? ?? '',
      customerPhone: doc['customerPhone'] as String? ?? '',
      customerEmail: doc['customerEmail'] as String? ?? '',
      items: (doc['items'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(OrderItem.fromMap)
          .toList(),
      totalPrice: (doc['totalPrice'] as num?)?.toDouble() ?? 0,
      status: doc['status'] as String? ?? 'pending',
      paymentMethod: doc['paymentMethod'] as String? ?? 'cash',
      createdAt: parsedCreatedAt,
      deliveryAddress: doc['deliveryAddress'] as String?,
      notes: doc['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        customerName,
        customerPhone,
        customerEmail,
        items,
        totalPrice,
        status,
        paymentMethod,
        createdAt,
        deliveryAddress,
        notes,
      ];
}
