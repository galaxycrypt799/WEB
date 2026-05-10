import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'app_bootstrap.dart';
import 'simple_bloc_observer.dart';

Future<void> main() async {
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  final bootstrap = await AppBootstrap.initialize();
  runApp(MyApp(bootstrap: bootstrap));
}
