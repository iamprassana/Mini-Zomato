import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato/data/models/restaurant.dart';
import 'package:mini_zomato/repositories/auth_repository.dart';

// Events
abstract class RestaurantListEvent {}

class LoadRestaurants extends RestaurantListEvent {}

class FilterRestaurants extends RestaurantListEvent {
  final String category;
  final String searchQuery;

  FilterRestaurants({required this.category, required this.searchQuery});
}

// States
abstract class RestaurantListState {}

class RestaurantListInitial extends RestaurantListState {}

class RestaurantListLoading extends RestaurantListState {}

class RestaurantListLoaded extends RestaurantListState {
  final List<Restaurant> restaurants;
  final String selectedCategory;
  final String searchQuery;

  RestaurantListLoaded({
    required this.restaurants,
    required this.selectedCategory,
    required this.searchQuery,
  });
}

class RestaurantListError extends RestaurantListState {
  final String message;

  RestaurantListError({required this.message});
}

// BLoC
class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  final AuthRepository authRepository;

  RestaurantListBloc({required this.authRepository})
    : super(RestaurantListInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
  }

  void _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantListState> emit,
  ) {
    emit(RestaurantListLoading());
    try {
      final restaurants = authRepository.getRestaurants();
      emit(
        RestaurantListLoaded(
          restaurants: restaurants,
          selectedCategory: 'All',
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }

  void _onFilterRestaurants(
    FilterRestaurants event,
    Emitter<RestaurantListState> emit,
  ) {
    if (state is RestaurantListLoaded) {
      List<Restaurant> filteredRestaurants = authRepository.getRestaurants();

      // Filter by category
      if (event.category != 'All') {
        filteredRestaurants = filteredRestaurants
            .where((r) => r.cuisine == event.category)
            .toList();
      }

      // Filter by search query
      if (event.searchQuery.isNotEmpty) {
        filteredRestaurants = filteredRestaurants
            .where(
              (r) =>
                  r.name.toLowerCase().contains(
                    event.searchQuery.toLowerCase(),
                  ) ||
                  r.cuisine.toLowerCase().contains(
                    event.searchQuery.toLowerCase(),
                  ),
            )
            .toList();
      }

      emit(
        RestaurantListLoaded(
          restaurants: filteredRestaurants,
          selectedCategory: event.category,
          searchQuery: event.searchQuery,
        ),
      );
    }
  }
}
