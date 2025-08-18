import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:project_v1/modules/home.dart';
import 'package:project_v1/modules/theme/colors.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});
  @override
  State<Layout> createState() => _Layout(); 
}
class _Layout extends State<Layout> {
  @override
  //Навигация по экранам
  int _screenIndex = 0;
  Widget build(BuildContext context) {
    // медия запросы
    final screenWidth = MediaQuery.of(context).size.width;
    final footbarCardTitleStyle = TextStyle(
      fontFamily: 'Gilroy',
      fontSize: 8,
      fontWeight: FontWeight.w500,
      color: AppColors.text,
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundComplimentary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
          child: AppBar(
          backgroundColor: AppColors.backgroundComplimentary,
          title: Center(
            child: Image.asset(
              'lib/assets/images/champion_yellow.png',
              width: 80,
              height: 80
            )
          ),
        )
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _screenIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _screenIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_none),
            label: 'Updates',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _screenIndex,
          children: [
            HomePage(),
            Container(
              color: Colors.orange
            )
          ],
        )
      )
    );
  }
}