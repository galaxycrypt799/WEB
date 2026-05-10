part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
  @override
  List<Object> get props => [];
}

class GetOrders extends OrdersEvent {}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final String status;
  const UpdateOrderStatus(this.orderId, this.status);
  @override
  List<Object> get props => [orderId, status];
}