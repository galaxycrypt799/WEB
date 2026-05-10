import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'orders_bloc.dart';
import 'revenue_bloc.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'preparing': return Colors.deepPurple;
      case 'ready': return Colors.teal;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton.filledTonal(
                onPressed: () {
                  context.read<OrdersBloc>().add(GetOrders());
                  context.read<RevenueBloc>().add(GetRevenueRequested());
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
          ),
          BlocBuilder<RevenueBloc, RevenueState>(
            builder: (context, state) {
              if (state is RevenueSuccess) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("Hôm nay", formatVnd(state.today)),
                      _buildStatItem("Tháng này", formatVnd(state.month)),
                      _buildStatItem("Đã giao", state.completedOrders.toString()),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(child: _buildOrdersList()),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) return const Center(child: CircularProgressIndicator());
          if (state is OrdersFailure) return const Center(child: Text("Không thể tải đơn hàng"));
          if (state is OrdersSuccess) {
            if (state.orders.isEmpty) return const Center(child: Text("Chưa có đơn hàng nào"));
            
            return ListView.builder(
              itemCount: state.orders.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(order.status),
                      child: const Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    title: Text("Đơn hàng: #${order.id.substring(0, 8)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Khách: ${order.customerName} • ${DateFormat('HH:mm dd/MM').format(order.createdAt)}"),
                    trailing: DropdownButton<String>(
                      value: order.status,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'pending', child: Text("Chờ")),
                        DropdownMenuItem(value: 'confirmed', child: Text("Đã nhận")),
                        DropdownMenuItem(value: 'preparing', child: Text("Đang pha")),
                        DropdownMenuItem(value: 'ready', child: Text("Sẵn sàng")),
                        DropdownMenuItem(value: 'delivered', child: Text("Đã giao")),
                        DropdownMenuItem(value: 'cancelled', child: Text("Hủy")),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          context.read<OrdersBloc>().add(UpdateOrderStatus(order.id, val));
                        }
                      },
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${item.quantity}x ${item.name}"),
                                  Text(formatVnd(item.price * item.quantity)),
                                ],
                              ),
                            )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tổng cộng:", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(formatVnd(order.totalPrice), style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
