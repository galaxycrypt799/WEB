import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:coffee_admin/src/modules/operations/views/cart_bloc.dart';
import 'package:coffee_admin/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_admin/src/modules/operations/views/order.dart';
import 'package:coffee_admin/src/modules/operations/views/order_repo.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Giỏ hàng của bạn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text("Giỏ hàng đang trống", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.local_drink, color: Colors.brown),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${formatVnd(item.price)} x ${item.quantity}",
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  context.read<CartBloc>().add(CartItemRemoved(item.coffeeId));
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildCheckoutSection(context, state),
              ],
            );
          }
          
          return const Center(child: Text("Đã có lỗi xảy ra"));
        },
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng cộng", style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text(
                  formatVnd(state.totalAmount),
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () async {
                  final user = context.read<AuthenticationBloc>().state.user;
                  if (user == null) return;

                  final order = Order(
                    id: '',
                    userId: user.userId,
                    customerName: user.name,
                    customerPhone: '',
                    customerEmail: user.email,
                    items: state.items,
                    totalPrice: state.totalAmount.toDouble(),
                    status: 'pending',
                    paymentMethod: 'cash',
                    createdAt: DateTime.now(),
                  );

                  try {
                    await context.read<OrderRepo>().createOrder(order);
                    if (context.mounted) {
                      // Sau khi đặt thành công, reset giỏ hàng và về Home
                      context.read<CartBloc>().add(CartStarted());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đặt hàng thành công! Đang chờ Admin xác nhận.")),
                      );
                      context.go('/home');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lỗi khi đặt hàng, vui lòng thử lại.")),
                      );
                    }
                  }
                },
                child: const Text("Xác nhận thanh toán", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
