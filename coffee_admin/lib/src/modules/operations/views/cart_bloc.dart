import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffee_admin/src/modules/operations/views/order_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }

  void _onStarted(CartStarted event, Emitter<CartState> emit) {
    emit(const CartLoaded());
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      final items = List<OrderItem>.from(state.items);
      
      // Kiểm tra món đã tồn tại trong giỏ chưa
      final index = items.indexWhere((item) => item.coffeeId == event.coffee.coffeeId);

      if (index >= 0) {
        // Nếu có rồi thì tăng số lượng
        final currentItem = items[index];
        items[index] = OrderItem(
          coffeeId: currentItem.coffeeId,
          name: currentItem.name,
          quantity: currentItem.quantity + 1,
          price: currentItem.price,
        );
      } else {
        // Nếu chưa có thì thêm mới
        items.add(OrderItem(
          coffeeId: event.coffee.coffeeId,
          name: event.coffee.name,
          quantity: 1,
          price: event.coffee.discountedPrice,
        ));
      }

      emit(CartLoaded(
        items: items,
        totalAmount: _calculateTotal(items),
      ));
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      final items = List<OrderItem>.from(state.items)
        ..removeWhere((item) => item.coffeeId == event.coffeeId);

      emit(CartLoaded(
        items: items,
        totalAmount: _calculateTotal(items),
      ));
    }
  }

  int _calculateTotal(List<OrderItem> items) {
    return items.fold<int>(
      0,
      (total, item) => total + (item.price * item.quantity).round(),
    );
  }
}
