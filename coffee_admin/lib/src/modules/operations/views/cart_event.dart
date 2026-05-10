part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Coffee coffee;
  const CartItemAdded(this.coffee);

  @override
  List<Object?> get props => [coffee];
}

class CartItemRemoved extends CartEvent {
  final String coffeeId;
  const CartItemRemoved(this.coffeeId);

  @override
  List<Object?> get props => [coffeeId];
}