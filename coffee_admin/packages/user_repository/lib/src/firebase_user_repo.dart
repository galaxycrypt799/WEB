import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users');

  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> _usersCollection;

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return MyUser.empty;
      }

      final snapshot = await _usersCollection.doc(firebaseUser.uid).get();
      final data = snapshot.data();

      if (data == null) {
        final fallbackUser = MyUser(
          userId: firebaseUser.uid,
          email: firebaseUser.email?.trim().toLowerCase() ?? '',
          name: firebaseUser.displayName?.trim().isNotEmpty == true
              ? firebaseUser.displayName!.trim()
              : 'Coffee Admin',
          hasActiveCart: false,
        );
        await setUserData(fallbackUser);
        return fallbackUser;
      }

      return MyUser.fromEntity(MyUserEntity.fromDocument(data));
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (error, stackTrace) {
      log('Firebase sign-in failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email.trim(),
        password: password,
      );

      final createdUser = MyUser(
        userId: credential.user!.uid,
        email: myUser.email.trim().toLowerCase(),
        name: myUser.name.trim(),
        hasActiveCart: myUser.hasActiveCart,
      );

      await credential.user!.updateDisplayName(createdUser.name);
      return createdUser;
    } catch (error, stackTrace) {
      log('Firebase sign-up failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await _usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (error, stackTrace) {
      log('Saving Firebase user data failed',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
