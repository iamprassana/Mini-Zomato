import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_zomato/bloc/authentication/auth_bloc.dart';
import 'package:mini_zomato/bloc/restaurant_list/restaurant_list_bloc.dart';
import 'package:mini_zomato/bloc/menu/menu_bloc.dart';
import 'package:mini_zomato/bloc/cart/cart_bloc.dart';
import 'package:mini_zomato/bloc/order/order_bloc.dart';
import 'package:mini_zomato/bloc/order_history/order_history_bloc.dart';
import 'package:mini_zomato/repositories/auth_repository.dart';
import 'package:mini_zomato/data/data_sources/remote/firebase_functions.dart';
import 'package:mini_zomato/presentations/user/login.dart';
import 'package:mini_zomato/presentations/user/register_page.dart';
import 'package:mini_zomato/presentations/user/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Create a single instance of the repository to share
  final authRepository = FirebaseAuthRepository(FirebaseAuthRemoteDataSource());
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        BlocProvider<RestaurantListBloc>(
          create: (context) => RestaurantListBloc(authRepository: authRepository),
        ),
        BlocProvider<MenuBloc>(create: (context) => MenuBloc()),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
        BlocProvider<OrderHistoryBloc>(create: (context) => OrderHistoryBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return _buildState(state);
        },
      ),
    );
  }

  Widget _buildState(AuthState state) {
    if (state is AuthInitial) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing...'),
            ],
          ),
        ),
      );
    } else if (state is AuthLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      );
    } else if (state is UnAuthenticated) {
      return const LoginPage();
    } else if (state is AuthRegister) {
      return RegisterPage(email: state.email, password: state.passWord);
    } else if (state is Authenticated) {
      return HomePage();
    } else if (state is AuthenticationError) {
      return const LoginPage();
    } else {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Unknown State...'),
            ],
          ),
        ),
      );
    }
  }
}
