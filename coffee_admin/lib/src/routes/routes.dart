import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:coffee_admin/src/blocs/authentication_bloc/authentication_bloc.dart';

import '../modules/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/base/views/base_screen.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/operations/blocs/create_coffee_bloc/create_coffee_bloc.dart';
import '../modules/operations/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import '../modules/operations/views/create_coffee_screen.dart';
import '../modules/operations/views/orders_bloc.dart';
import '../modules/operations/views/my_orders_bloc.dart';
import '../modules/operations/views/orders_screen.dart';
import '../modules/operations/views/profile_screen.dart';
import '../modules/operations/views/revenue_bloc.dart';
import '../modules/operations/views/order_repo.dart';
import '../modules/splash/views/splash_screen.dart';

final _navKey = GlobalKey<NavigatorState>();
final _shellNavigationKey = GlobalKey<NavigatorState>();

GoRouter router(AuthenticationBloc authBloc) {
  return GoRouter(
    navigatorKey: _navKey,
    initialLocation: '/',
    redirect: (context, state) {
      if(authBloc.state.status == AuthenticationStatus.unknown) {
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigationKey,
        builder: (context, state, child) {
          if(state.fullPath == '/login' || state.fullPath == '/' ) {
            return child;
          } else {
            return BlocProvider<SignInBloc>(
              create: (context) => SignInBloc(
                context.read<AuthenticationBloc>().userRepository
              ),
              child: BaseScreen(child)
            );
          }
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: const SplashScreen(),
            )
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: BlocProvider<SignInBloc>(
                create: (context) => SignInBloc(
                  context.read<AuthenticationBloc>().userRepository
                ),
                child: const SignInScreen(),
              ),
            )
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => BlocProvider(
              create: (context) => RevenueBloc(context.read<OrderRepo>())
                ..add(GetRevenueRequested()),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) {
              final coffeeRepo = context.read<CoffeeRepo>();

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CreateCoffeeBloc(coffeeRepo),
                  ),
                  BlocProvider(
                    create: (context) => UploadPictureBloc(coffeeRepo),
                  ),
                ],
                child: const CreateCoffeeScreen(),
              );
            },
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      OrdersBloc(context.read<OrderRepo>())..add(GetOrders()),
                ),
                BlocProvider(
                  create: (context) => RevenueBloc(context.read<OrderRepo>())
                    ..add(GetRevenueRequested()),
                ),
              ],
              child: const OrdersScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => BlocProvider(
              create: (context) => MyOrdersBloc(context.read<OrderRepo>())
                ..add(GetMyOrdersRequested(authBloc.state.user?.userId ?? '')),
              child: const ProfileScreen(),
            ),
          ),
        ]
      )
    ]
  );
}
