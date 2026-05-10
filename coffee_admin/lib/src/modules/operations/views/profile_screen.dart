import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:coffee_admin/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';

import 'my_orders_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.user;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? "Khách hàng", style: Theme.of(context).textTheme.headlineSmall),
                    Text(user?.email ?? "", style: const TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            const Text("Đơn hàng gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<MyOrdersBloc, MyOrdersState>(
              builder: (context, state) {
                if (state is MyOrdersLoading) return const Center(child: CircularProgressIndicator());
                if (state is MyOrdersFailure) return const Center(child: Text("Không thể tải lịch sử đơn hàng"));
                if (state is MyOrdersSuccess) {
                  if (state.orders.isEmpty) return const Text("Bạn chưa có đơn hàng nào.");

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text("Đơn #${order.id.substring(0, 8)}"),
                          subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatVnd(order.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
                              _buildStatusBadge(order.status),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'delivered':
        color = Colors.green;
        text = "Đã giao";
        break;
      case 'ready':
        color = Colors.teal;
        text = "Sẵn sàng";
        break;
      case 'preparing':
        color = Colors.deepPurple;
        text = "Đang pha chế";
        break;
      case 'confirmed':
        color = Colors.blue;
        text = "Đã xác nhận";
        break;
      case 'cancelled':
        color = Colors.red;
        text = "Đã hủy";
        break;
      default:
        color = Colors.orange;
        text = "Chờ xác nhận";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
