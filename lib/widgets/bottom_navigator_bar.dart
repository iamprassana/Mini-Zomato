import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigatorBar extends StatelessWidget {
  const BottomNavigatorBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: GNav(
            haptic: false,
            backgroundColor: Colors.white,
            gap: 9,
            color: Colors.white,
            activeColor: Colors.black,
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconColor: Colors.black,
                textColor: Colors.black,
              ),
              GButton(
                icon: Icons.history,
                text: 'Orders',
                iconColor: Colors.black,
                textColor: Colors.black,
              ),
              GButton(
                icon: Icons.shopping_cart_rounded,
                text: 'Cart',
                iconColor: Colors.black,
                textColor: Colors.black,
              ),
              GButton(
                icon: Icons.person,
                text: 'Account',
                iconColor: Colors.black,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
