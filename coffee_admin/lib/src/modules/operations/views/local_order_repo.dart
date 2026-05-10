import 'package:coffee_admin/src/modules/operations/views/order.dart';
import 'package:coffee_admin/src/modules/operations/views/order_item.dart';
import 'package:coffee_admin/src/modules/operations/views/order_repo.dart';

class LocalOrderRepo implements OrderRepo {
  final List<Order> _orders = <Order>[
    Order(
      id: 'order-local-001',
      userId: 'local-guest',
      customerName: 'Nguyễn Văn A',
      customerPhone: '0900000001',
      customerEmail: 'guest@roastritual.app',
      items: const [
        OrderItem(
          coffeeId: 'phin-sua-da-signature',
          name: 'Phin Sữa Đá',
          quantity: 2,
          price: 49000,
        ),
      ],
      totalPrice: 98000,
      status: 'pending',
      paymentMethod: 'cash',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Order(
      id: 'order-local-002',
      userId: 'local-admin',
      customerName: 'Trần Thị B',
      customerPhone: '0900000002',
      customerEmail: 'admin@roastritual.app',
      items: const [
        OrderItem(
          coffeeId: 'cold-brew-cam',
          name: 'Cold Brew Cam',
          quantity: 1,
          price: 59000,
        ),
      ],
      totalPrice: 59000,
      status: 'delivered',
      paymentMethod: 'card',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Future<void> createOrder(Order order) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _orders.insert(0, order);
  }

  @override
  Future<List<Order>> getMyOrders(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _orders
        .where((order) => order.userId == userId)
        .toList(growable: false);
  }

  @override
  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders.toList(growable: false);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      return;
    }
    _orders[index] = _orders[index].copyWith(status: status);
  }

  @override
  Future<Map<String, dynamic>> getRevenueStats() async {
    final deliveredOrders = _orders
        .where((order) => order.status == 'delivered')
        .toList(growable: false);

    return {
      'today': deliveredOrders
          .where((order) => order.createdAt.day == DateTime.now().day)
          .fold<int>(0, (sum, order) => sum + order.totalPrice.round()),
      'month': deliveredOrders.fold<int>(
        0,
        (sum, order) => sum + order.totalPrice.round(),
      ),
      'count': deliveredOrders.length,
      'weekly': <int>[200000, 450000, 300000, 800000, 600000, 150000, 900000],
    };
  }
}
