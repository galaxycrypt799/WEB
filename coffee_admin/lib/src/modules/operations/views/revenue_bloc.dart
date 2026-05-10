import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'order_repo.dart';

part 'revenue_event.dart';
part 'revenue_state.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final OrderRepo _orderRepo;

  RevenueBloc(this._orderRepo) : super(RevenueInitial()) {
    on<GetRevenueRequested>((event, emit) async {
      emit(RevenueLoading());
      try {
        final stats = await _orderRepo.getRevenueStats();
        emit(RevenueSuccess(
          stats['today'] as int,
          stats['month'] as int,
          stats['count'] as int,
          stats['weekly'] as List<int>,
        ));
      } catch (e) {
        emit(RevenueFailure());
      }
    });
  }
}