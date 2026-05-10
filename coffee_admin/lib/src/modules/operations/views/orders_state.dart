part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {}
class OrdersFailure extends OrdersState {}
class OrdersSuccess extends OrdersState {
  final List<Order> orders;
  const OrdersSuccess(this.orders);
  @override
  List<Object> get props => [orders];
}