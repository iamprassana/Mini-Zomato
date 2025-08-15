import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_zomato/data/data_sources/remote/firebase_functions.dart';
import 'package:mini_zomato/data/models/restaurant.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;
  Future<void> signIn({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<String?> getUserDisplayName();
  List<Restaurant> getRestaurants();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._remote);

  final FirebaseAuthRemoteDataSource _remote;

  @override
  Stream<User?> authStateChanges() => _remote.authStateChanges();

  @override
  User? get currentUser => _remote.currentUser;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _remote.signIn(email: email, password: password);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _remote.register(name: name, email: email, password: password);
  }

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<String?> getUserDisplayName() => _remote.getUserDisplayName();

  @override
  List<Restaurant> getRestaurants() => _remote.getFakeRestaurants();
}
