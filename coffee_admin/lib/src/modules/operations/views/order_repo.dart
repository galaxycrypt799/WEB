import 'order.dart';

abstract class OrderRepo {
  Future<void> createOrder(Order order);
  Future<List<Order>> getMyOrders(String userId);
  Future<List<Order>> getOrders();
  Future<void> updateOrderStatus(String orderId, String status);
  Future<Map<String, dynamic>> getRevenueStats();
}