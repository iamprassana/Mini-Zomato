import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato/data/models/order.dart';
import 'package:mini_zomato/data/models/restaurant.dart';

// Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final MenuItem item;
  final String restaurantName;

  AddToCart({required this.item, required this.restaurantName});
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  RemoveFromCart({required this.itemId});
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  UpdateQuantity({required this.itemId, required this.quantity});
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalAmount;
  final int totalItems;

  CartLoaded({
    required this.items,
    required this.totalAmount,
    required this.totalItems,
  });
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == event.item.id);

    if (existingIndex != -1) {
      // Update quantity if item already exists
      _cartItems[existingIndex] = CartItem(
        id: _cartItems[existingIndex].id,
        name: _cartItems[existingIndex].name,
        description: _cartItems[existingIndex].description,
        price: _cartItems[existingIndex].price,
        imageUrl: _cartItems[existingIndex].imageUrl,
        quantity: _cartItems[existingIndex].quantity + 1,
        restaurantName: _cartItems[existingIndex].restaurantName,
      );
    } else {
      // Add new item
      _cartItems.add(CartItem(
        id: event.item.id,
        name: event.item.name,
        description: event.item.description,
        price: event.item.price,
        imageUrl: event.item.imageUrl,
        quantity: 1,
        restaurantName: event.restaurantName,
      ));
    }

    _emitCartState(emit);
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    _cartItems.removeWhere((item) => item.id == event.itemId);
    _emitCartState(emit);
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      _cartItems.removeWhere((item) => item.id == event.itemId);
    } else {
      final index = _cartItems.indexWhere((item) => item.id == event.itemId);
      if (index != -1) {
        _cartItems[index] = CartItem(
          id: _cartItems[index].id,
          name: _cartItems[index].name,
          description: _cartItems[index].description,
          price: _cartItems[index].price,
          imageUrl: _cartItems[index].imageUrl,
          quantity: event.quantity,
          restaurantName: _cartItems[index].restaurantName,
        );
      }
    }
    _emitCartState(emit);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _cartItems.clear();
    emit(CartEmpty());
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    _emitCartState(emit);
  }

  void _emitCartState(Emitter<CartState> emit) {
    if (_cartItems.isEmpty) {
      emit(CartEmpty());
    } else {
      final totalAmount = _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      final totalItems = _cartItems.fold(0, (sum, item) => sum + item.quantity);

      emit(CartLoaded(
        items: List.from(_cartItems),
        totalAmount: totalAmount,
        totalItems: totalItems,
      ));
    }
  }
}
