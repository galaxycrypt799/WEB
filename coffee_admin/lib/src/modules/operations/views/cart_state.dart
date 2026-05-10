part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
  
  @override
  List<Object?> get props => [];
}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<OrderItem> items;
  final int totalAmount;

  const CartLoaded({
    this.items = const [],
    this.totalAmount = 0,
  });

  @override
  List<Object?> get props => [items, totalAmount];
}

final class CartError extends CartState {}