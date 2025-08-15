import 'package:flutter/material.dart';
import 'package:mini_zomato/data/models/restaurant.dart';

class MenuPage extends StatefulWidget {
  final Restaurant restaurant;

  const MenuPage({super.key, required this.restaurant});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Map<String, int> cart = {};
  double totalAmount = 0;

  void addToCart(MenuItem item) {
    setState(() {
      if (cart.containsKey(item.id)) {
        cart[item.id] = cart[item.id]! + 1;
      } else {
        cart[item.id] = 1;
      }
      totalAmount = cart.entries.fold(0, (sum, entry) {
        final item = widget.restaurant.menu.firstWhere((m) => m.id == entry.key);
        return sum + (item.price * entry.value);
      });
    });
  }

  void removeFromCart(MenuItem item) {
    setState(() {
      if (cart.containsKey(item.id) && cart[item.id]! > 0) {
        cart[item.id] = cart[item.id]! - 1;
        if (cart[item.id] == 0) {
          cart.remove(item.id);
        }
        totalAmount = cart.entries.fold(0, (sum, entry) {
          final item = widget.restaurant.menu.firstWhere((m) => m.id == entry.key);
          return sum + (item.price * entry.value);
        });
      }
    });
  }

  void placeOrder() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add items to cart first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed!'),
        content: Text('Your order has been placed successfully. Order total: ₹${totalAmount.toStringAsFixed(0)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.restaurant.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Restaurant Info Header
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            widget.restaurant.rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.restaurant.cuisine,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      '${widget.restaurant.deliveryTime} min',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.delivery_dining, size: 14, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      '₹${widget.restaurant.deliveryFee.toStringAsFixed(0)} delivery',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.restaurant.menu.length,
              itemBuilder: (context, index) {
                final item = widget.restaurant.menu[index];
                final quantity = cart[item.id] ?? 0;

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: Icon(Icons.restaurant, color: Colors.grey[600]),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),

                        // Item Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (item.isVeg)
                                    Icon(Icons.circle, color: Colors.green, size: 16),
                                  if (item.isSpicy)
                                    Icon(Icons.whatshot, color: Colors.red, size: 16),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₹${item.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Add to Cart Button
                        Column(
                          children: [
                            if (quantity == 0)
                              ElevatedButton(
                                onPressed: () => addToCart(item),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'ADD',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => removeFromCart(item),
                                    icon: Icon(Icons.remove, color: Colors.red),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.withOpacity(0.1),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => addToCart(item),
                                    icon: Icon(Icons.add, color: Colors.red),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.withOpacity(0.1),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: cart.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: ₹${totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${cart.values.fold(0, (sum, quantity) => sum + quantity)} items',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'PLACE ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
