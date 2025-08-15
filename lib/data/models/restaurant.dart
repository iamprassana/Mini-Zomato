class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final String address;
  final List<MenuItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.address,
    required this.menu,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isVeg;
  final bool isSpicy;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isVeg,
    required this.isSpicy,
  });
}
