import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:coffee_admin/src/modules/operations/views/order.dart';
import 'package:coffee_admin/src/modules/operations/views/order_repo.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final OrderRepo _orderRepo;

  MyOrdersBloc(this._orderRepo) : super(MyOrdersInitial()) {
    on<GetMyOrdersRequested>((event, emit) async {
      emit(MyOrdersLoading());
      try {
        final orders = await _orderRepo.getMyOrders(event.userId);
        emit(MyOrdersSuccess(orders));
      } catch (e) {
        emit(MyOrdersFailure());
      }
    });
  }
}

abstract class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetMyOrdersRequested extends MyOrdersEvent {
  final String userId;

  const GetMyOrdersRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

class MyOrdersInitial extends MyOrdersState {}
class MyOrdersLoading extends MyOrdersState {}
class MyOrdersFailure extends MyOrdersState {}

class MyOrdersSuccess extends MyOrdersState {
  final List<Order> orders;

  const MyOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}
