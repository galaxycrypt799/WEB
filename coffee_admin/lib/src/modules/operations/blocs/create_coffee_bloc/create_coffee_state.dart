part of 'create_coffee_bloc.dart';

sealed class CreateCoffeeState extends Equatable {
  const CreateCoffeeState();

  @override
  List<Object> get props => [];
}

final class CreateCoffeeInitial extends CreateCoffeeState {}

final class CreateCoffeeFailure extends CreateCoffeeState {}
final class CreateCoffeeLoading extends CreateCoffeeState {}
final class CreateCoffeeSuccess extends CreateCoffeeState {}
