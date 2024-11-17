import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.child});

  final Widget child;

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/appointments');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState goRouterState = GoRouterState.of(context);
    final String currentLocation = goRouterState.location;

    final showBottomNavigationBar =
        !currentLocation.startsWith('/service_page');

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: showBottomNavigationBar
          ? SlidingClippedNavBar(
              backgroundColor: Colors.white,
              onButtonPressed: _onItemTapped,
              iconSize: 30,
              activeColor: Colors.blue,
              selectedIndex: _selectedIndex,
              barItems: [
                BarItem(icon: Icons.home, title: 'Home'),
                BarItem(icon: Icons.search, title: 'Search'),
                BarItem(icon: Icons.history, title: 'Appointments'),
                BarItem(icon: Icons.person, title: 'Profile'),
              ],
            )
          : null,
    );
  }
}
