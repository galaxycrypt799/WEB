part of 'create_coffee_bloc.dart';

sealed class CreateCoffeeEvent extends Equatable {
  const CreateCoffeeEvent();

  @override
  List<Object> get props => [];
}

class CreateCoffeeRequested extends CreateCoffeeEvent {
  final Coffee coffee;

  const CreateCoffeeRequested(this.coffee);

  @override
  List<Object> get props => [coffee];
}
