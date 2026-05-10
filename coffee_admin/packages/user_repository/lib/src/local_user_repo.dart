import 'dart:async';

import 'package:user_repository/user_repository.dart';

class LocalUserRepo implements UserRepository {
  LocalUserRepo();

  final StreamController<MyUser?> _userController =
      StreamController<MyUser?>.broadcast();
  final Map<String, _StoredUser> _users = <String, _StoredUser>{
    'admin@roastritual.app': _StoredUser(
      user: MyUser(
        userId: 'local-admin',
        email: 'admin@roastritual.app',
        name: 'Coffee Admin',
        hasActiveCart: false,
      ),
      password: 'Admin@123',
    ),
  };

  MyUser _currentUser = MyUser.empty;

  @override
  Stream<MyUser?> get user async* {
    yield _currentUser; // Phát ra trạng thái hiện tại ngay lập tức
    yield* _userController.stream;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final account = _users[normalizedEmail];

    if (account == null || account.password != password) {
      throw StateError('Invalid email or password');
    }

    _currentUser = account.user;
    _userController.add(_currentUser);
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = myUser.email.trim().toLowerCase();

    if (_users.containsKey(normalizedEmail)) {
      throw StateError('Email already exists');
    }

    final createdUser = MyUser(
      userId: 'local-${DateTime.now().microsecondsSinceEpoch}',
      email: normalizedEmail,
      name: myUser.name.trim(),
      hasActiveCart: myUser.hasActiveCart,
    );

    _users[normalizedEmail] = _StoredUser(
      user: createdUser,
      password: password,
    );
    _currentUser = createdUser;
    _userController.add(_currentUser);
    return createdUser;
  }

  @override
  Future<void> logOut() async {
    _currentUser = MyUser.empty;
    _userController.add(_currentUser);
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    final normalizedEmail = myUser.email.trim().toLowerCase();
    final current = _users[normalizedEmail];
    if (current == null) {
      return;
    }

    _users[normalizedEmail] = _StoredUser(
      user: myUser,
      password: current.password,
    );
    _currentUser = myUser;
    _userController.add(_currentUser);
  }
}

class _StoredUser {
  const _StoredUser({
    required this.user,
    required this.password,
  });

  final MyUser user;
  final String password;
}
