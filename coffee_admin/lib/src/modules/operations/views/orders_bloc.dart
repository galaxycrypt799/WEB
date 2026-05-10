import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'order.dart';
import 'order_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepo _orderRepo;

  OrdersBloc(this._orderRepo) : super(OrdersLoading()) {
    on<GetOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await _orderRepo.getOrders();
        emit(OrdersSuccess(orders));
      } catch (e) {
        emit(OrdersFailure());
      }
    });

    on<UpdateOrderStatus>((event, emit) async {
      try {
        await _orderRepo.updateOrderStatus(event.orderId, event.status);
        add(GetOrders()); // Refresh list
      } catch (e) {
        emit(OrdersFailure());
      }
    });
  }
}