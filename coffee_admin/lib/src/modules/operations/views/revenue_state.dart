part of 'revenue_bloc.dart';

sealed class RevenueState extends Equatable {
  const RevenueState();
  
  @override
  List<Object> get props => [];
}

final class RevenueInitial extends RevenueState {}
final class RevenueLoading extends RevenueState {}
final class RevenueFailure extends RevenueState {}
final class RevenueSuccess extends RevenueState {
  final int today;
  final int month;
  final int completedOrders;
  final List<int> weeklyRevenue;

  const RevenueSuccess(this.today, this.month, this.completedOrders, this.weeklyRevenue);

  @override
  List<Object> get props => [today, month, completedOrders, weeklyRevenue];
}