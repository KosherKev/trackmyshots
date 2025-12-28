import 'package:flutter/material.dart';
import 'package:trackmyshots/screens/home_screen.dart';
import 'package:trackmyshots/screens/tracking_screen.dart';
import 'package:trackmyshots/screens/profile_screen.dart';
import 'package:trackmyshots/screens/educational_resources_screen.dart';
import 'package:trackmyshots/screens/reminders_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainScreen({
    super.key, 
    this.initialIndex = 2, // Default to Home
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Smoothly animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Optional: for nicer feel
        children: const [
          TrackingScreen(),
          ProfileScreen(),
          HomeScreen(),
          EducationalResourcesScreen(),
          RemindersScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.track_changes, 0),
          _buildNavIcon(Icons.person, 1),
          _buildNavIcon(Icons.home, 2),
          _buildNavIcon(Icons.medical_services, 3),
          _buildNavIcon(Icons.assignment, 4),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0066B3) : const Color(0xFF757575),
          size: 28,
        ),
      ),
    );
  }
}
