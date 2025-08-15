import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato/data/models/order.dart';

// Events
abstract class OrderHistoryEvent {}

class LoadOrderHistory extends OrderHistoryEvent {}

class FilterOrdersByStatus extends OrderHistoryEvent {
  final String status;

  FilterOrdersByStatus({required this.status});
}

// States
abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<Order> currentOrders;
  final List<Order> pastOrders;

  OrderHistoryLoaded({
    required this.currentOrders,
    required this.pastOrders,
  });
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError({required this.message});
}

// BLoC
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
  }

  void _onLoadOrderHistory(LoadOrderHistory event, Emitter<OrderHistoryState> emit) {
    emit(OrderHistoryLoading());
    try {
      // Sample orders data - in real app, this would come from a repository
      final currentOrders = [
        Order(
          id: '1',
          restaurantName: 'Punjabi Dhaba',
          items: [
            OrderItem(name: 'Butter Chicken', quantity: 2, price: 100),
            OrderItem(name: 'Dal Makhani', quantity: 1, price: 100),
          ],
          totalAmount: 300,
          status: 'Preparing',
          orderDate: DateTime.now().subtract(Duration(minutes: 15)),
          deliveryAddress: 'Amaravati, Andhra Pradesh',
          deliveryTime: 25,
        ),
        Order(
          id: '2',
          restaurantName: 'South Indian Delights',
          items: [
            OrderItem(name: 'Masala Dosa', quantity: 1, price: 100),
            OrderItem(name: 'Filter Coffee', quantity: 2, price: 100),
          ],
          totalAmount: 300,
          status: 'On the way',
          orderDate: DateTime.now().subtract(Duration(minutes: 45)),
          deliveryAddress: 'Amaravati, Andhra Pradesh',
          deliveryTime: 20,
        ),
      ];

      final pastOrders = [
        Order(
          id: '3',
          restaurantName: 'Andhra Spice House',
          items: [
            OrderItem(name: 'Andhra Chicken Curry', quantity: 1, price: 100),
            OrderItem(name: 'Gongura Pachadi', quantity: 1, price: 100),
          ],
          totalAmount: 200,
          status: 'Delivered',
          orderDate: DateTime.now().subtract(Duration(days: 2)),
          deliveryAddress: 'Amaravati, Andhra Pradesh',
          deliveryTime: 22,
        ),
        Order(
          id: '4',
          restaurantName: 'KFC India',
          items: [
            OrderItem(name: 'Chicken Bucket', quantity: 1, price: 100),
            OrderItem(name: 'Veg Zinger Burger', quantity: 2, price: 100),
          ],
          totalAmount: 300,
          status: 'Delivered',
          orderDate: DateTime.now().subtract(Duration(days: 5)),
          deliveryAddress: 'Amaravati, Andhra Pradesh',
          deliveryTime: 25,
        ),
      ];

      emit(OrderHistoryLoaded(
        currentOrders: currentOrders,
        pastOrders: pastOrders,
      ));
    } catch (e) {
      emit(OrderHistoryError(message: e.toString()));
    }
  }

  void _onFilterOrdersByStatus(FilterOrdersByStatus event, Emitter<OrderHistoryState> emit) {
    if (state is OrderHistoryLoaded) {
      final currentState = state as OrderHistoryLoaded;
      
      List<Order> filteredCurrentOrders = currentState.currentOrders;
      List<Order> filteredPastOrders = currentState.pastOrders;

      if (event.status != 'All') {
        filteredCurrentOrders = currentState.currentOrders
            .where((order) => order.status == event.status)
            .toList();
        filteredPastOrders = currentState.pastOrders
            .where((order) => order.status == event.status)
            .toList();
      }

      emit(OrderHistoryLoaded(
        currentOrders: filteredCurrentOrders,
        pastOrders: filteredPastOrders,
      ));
    }
  }
}
