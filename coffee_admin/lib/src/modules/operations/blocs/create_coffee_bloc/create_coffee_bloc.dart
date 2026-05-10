import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_coffee_event.dart';
part 'create_coffee_state.dart';

class CreateCoffeeBloc extends Bloc<CreateCoffeeEvent, CreateCoffeeState> {
  CreateCoffeeBloc(this._coffeeRepo) : super(CreateCoffeeInitial()) {
    on<CreateCoffeeRequested>((event, emit) async {
      emit(CreateCoffeeLoading());
      try {
        await _coffeeRepo.createCoffee(event.coffee);
        emit(CreateCoffeeSuccess());
      } catch (_) {
        emit(CreateCoffeeFailure());
      }
    });
  }

  final CoffeeRepo _coffeeRepo;
}
