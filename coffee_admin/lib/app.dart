import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'app_view.dart';
import 'app_bootstrap.dart';
import 'src/blocs/authentication_bloc/authentication_bloc.dart';
import 'src/modules/operations/views/order_repo.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    required this.bootstrap,
    super.key,
  });

  final AppBootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppBootstrap>.value(value: bootstrap),
        RepositoryProvider<UserRepository>.value(
          value: bootstrap.userRepository,
        ),
        RepositoryProvider<CoffeeRepo>.value(
          value: bootstrap.coffeeRepository,
        ),
        RepositoryProvider<OrderRepo>.value(
          value: bootstrap.orderRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          userRepository: context.read<UserRepository>(),
        ),
        child: const MyAppView(),
      ),
    );
  }
}
