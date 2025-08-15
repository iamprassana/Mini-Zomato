import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato/data/models/restaurant.dart';

// Events
abstract class MenuEvent {}

class LoadMenu extends MenuEvent {
  final Restaurant restaurant;

  LoadMenu({required this.restaurant});
}

class FilterMenuByCategory extends MenuEvent {
  final String category;

  FilterMenuByCategory({required this.category});
}

// States
abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final Restaurant restaurant;
  final List<MenuItem> menuItems;
  final String selectedCategory;

  MenuLoaded({
    required this.restaurant,
    required this.menuItems,
    required this.selectedCategory,
  });
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}

// BLoC
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
    on<FilterMenuByCategory>(_onFilterMenuByCategory);
  }

  void _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) {
    emit(MenuLoading());
    try {
      emit(MenuLoaded(
        restaurant: event.restaurant,
        menuItems: event.restaurant.menu,
        selectedCategory: 'All',
      ));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  void _onFilterMenuByCategory(FilterMenuByCategory event, Emitter<MenuState> emit) {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      List<MenuItem> filteredItems = currentState.restaurant.menu;

      if (event.category != 'All') {
        filteredItems = filteredItems
            .where((item) => item.category == event.category)
            .toList();
      }

      emit(MenuLoaded(
        restaurant: currentState.restaurant,
        menuItems: filteredItems,
        selectedCategory: event.category,
      ));
    }
  }
}
