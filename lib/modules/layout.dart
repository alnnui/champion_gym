import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:project_v1/modules/pages/home.dart';
import 'package:project_v1/modules/layout/footbar.dart';
import 'package:project_v1/modules/pages/profile.dart';
import 'package:project_v1/modules/pages/stats.dart';
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
  void changeScreen(int screenIndex) {
    setState(() {
      _screenIndex=screenIndex;
    });
  }
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
      backgroundColor: AppColors.background,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withAlpha(80),
              width: 2.0
            )
          )
        ),
        child: BottomAppBar(
          color: AppColors.backgroundComplimentary,
          child: Footbar(changeScreen: changeScreen,)
        )
      ),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _getScreen(_screenIndex),
        ),
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage(key: ValueKey(0));
      case 1:
        return StatsPage();
      case 2:
        return Container(
          key: const ValueKey(2),
          color: Colors.red,
          child: const Center(child: Text('Записи')),
        );
      case 3:
        return const ProfilePage(key: ValueKey(3));
      default:
        return const SizedBox.shrink();
    }
  }
}