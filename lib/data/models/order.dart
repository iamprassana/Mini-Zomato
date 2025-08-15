class Order {
  final String id;
  final String restaurantName;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final String deliveryAddress;
  final int deliveryTime;

  Order({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
    required this.deliveryTime,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  final String restaurantName;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.restaurantName,
  });
}
