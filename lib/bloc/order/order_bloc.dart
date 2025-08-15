import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato/data/models/order.dart';

// Events
abstract class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final List<CartItem> cartItems;
  final String deliveryAddress;

  PlaceOrder({required this.cartItems, required this.deliveryAddress});
}

class LoadOrders extends OrderEvent {}

// States
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;

  OrderPlaced({required this.order});
}

class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadOrders>(_onLoadOrders);
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    try {
      // Convert cart items to order items
      final orderItems = event.cartItems.map((cartItem) => OrderItem(
        name: cartItem.name,
        quantity: cartItem.quantity,
        price: cartItem.price,
      )).toList();

      // Calculate total amount
      final totalAmount = event.cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      // Create order
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantName: event.cartItems.first.restaurantName,
        items: orderItems,
        totalAmount: totalAmount,
        status: 'Preparing',
        orderDate: DateTime.now(),
        deliveryAddress: event.deliveryAddress,
        deliveryTime: 25, // Default delivery time
      );

      emit(OrderPlaced(order: order));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) {
    // This would typically load orders from a repository
    // For now, we'll just emit the initial state
    emit(OrderInitial());
  }
}
