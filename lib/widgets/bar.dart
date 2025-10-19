import "package:flutter/material.dart";

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      height: 80, //Adjusted height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.explore_outlined, 'Explore'),
          _buildNavItem(2, Icons.add_circle_outline_rounded, 'Add'),
          _buildNavItem(3, Icons.calendar_today_outlined, 'Trips'),
          _buildNavItem(4, Icons.person_outline_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconData, String label) {
    final bool isSelected = index == selectedIndex;

    // Colors used
    const Color darkBlue = Color(0xFF1E293B);
    const Color primaryBlue = Color(0xFF5A7CF9);
    const Color primaryPurple = Color(0xFF825AF9);
    const Color unselectedColor = Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //icon Area
          Container(
            width: 44,
            height: 44,
            child: Icon(
              // differect icon for selected item
              isSelected && index == 0 ? Icons.home_filled : iconData,

              color: isSelected ? Colors.blue : unselectedColor,
              size: isSelected ? 24 : 26,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? darkBlue : unselectedColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
