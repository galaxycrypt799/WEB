import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'order.dart';
import 'order_repo.dart';

class FirebaseOrderRepo implements OrderRepo {
  final orderCollection = firestore.FirebaseFirestore.instance.collection('orders');

  @override
  Future<void> createOrder(Order order) async {
    try {
      final docRef = orderCollection.doc();
      await docRef.set(order.copyWith(id: docRef.id).toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Order>> getMyOrders(String userId) async {
    try {
      final snapshot = await orderCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Order.fromDocument(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrders() async {
    try {
      final snapshot = await orderCollection.orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => Order.fromDocument(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await orderCollection.doc(orderId).update({'status': status});
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getRevenueStats() async {
    try {
      final snapshot = await orderCollection
          .where(
            'status',
            whereIn: <String>['delivered', 'completed'],
          )
          .get();
      int today = 0;
      int month = 0;
      List<int> weekly = List.filled(7, 0);

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final startOfThisMonth = DateTime(now.year, now.month, 1);

      for (var doc in snapshot.docs) {
        final order = Order.fromDocument(doc.data());
        final orderDate = DateTime(order.createdAt.year, order.createdAt.month, order.createdAt.day);
        
        if (order.createdAt.isAfter(startOfToday)) {
          today += order.totalPrice.round();
        }
        if (order.createdAt.isAfter(startOfThisMonth)) {
          month += order.totalPrice.round();
        }

        int dayDifference = startOfToday.difference(orderDate).inDays;
        if (dayDifference >= 0 && dayDifference < 7) {
          weekly[6 - dayDifference] += order.totalPrice.round();
        }
      }

      return {
        'today': today, 
        'month': month, 
        'count': snapshot.docs.length,
        'weekly': weekly
      };
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
