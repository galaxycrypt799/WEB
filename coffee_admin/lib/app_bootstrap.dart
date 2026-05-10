import 'dart:developer';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';

import 'firebase_options.dart';
import 'src/modules/operations/views/firebase_order_repo.dart';
import 'src/modules/operations/views/local_order_repo.dart';
import 'src/modules/operations/views/order_repo.dart';

enum BackendMode { firebase, local }

class AppBootstrap {
  const AppBootstrap._({
    required this.userRepository,
    required this.coffeeRepository,
    required this.orderRepository,
    required this.backendMode,
    required this.statusTitle,
    required this.statusMessage,
    this.warning,
  });

  final UserRepository userRepository;
  final CoffeeRepo coffeeRepository;
  final OrderRepo orderRepository;
  final BackendMode backendMode;
  final String statusTitle;
  final String statusMessage;
  final String? warning;

  bool get usesFirebase => backendMode == BackendMode.firebase;

  static Future<AppBootstrap> initialize() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      return _local(
        statusMessage:
            'Firebase chưa được cấu hình. Admin đang chạy bằng dữ liệu mẫu cục bộ.',
      );
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      return AppBootstrap._(
        userRepository: FirebaseUserRepo(),
        coffeeRepository: FirebaseCoffeeRepo(),
        orderRepository: FirebaseOrderRepo(),
        backendMode: BackendMode.firebase,
        statusTitle: 'Online',
        statusMessage:
            'DrinkHub Admin đang đọc và ghi trực tiếp vào Firebase dùng chung.',
      );
    } catch (error, stackTrace) {
      log(
        'Firebase initialization failed',
        error: error,
        stackTrace: stackTrace,
      );

      return _local(
        statusMessage:
            'Không thể kết nối Firebase. Admin đã chuyển sang chế độ cục bộ.',
        warning: error.toString(),
      );
    }
  }

  static AppBootstrap _local({
    required String statusMessage,
    String? warning,
  }) {
    return AppBootstrap._(
      userRepository: LocalUserRepo(),
      coffeeRepository: const LocalCoffeeRepo(),
      orderRepository: LocalOrderRepo(),
      backendMode: BackendMode.local,
      statusTitle: 'Offline',
      statusMessage: statusMessage,
      warning: warning,
    );
  }
}
