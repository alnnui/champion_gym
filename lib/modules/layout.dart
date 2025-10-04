import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/modules/pages/home.dart';
import 'package:myapp/modules/layout/footbar.dart';
import 'package:myapp/modules/pages/profile.dart';
import 'package:myapp/modules/pages/stats.dart';
import 'package:myapp/modules/pages/workouts.dart';
import 'package:myapp/modules/theme/colors.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});
  @override
  State<Layout> createState() => _Layout();
}

class _Layout extends State<Layout> {
  //Навигация по экранам
  int _screenIndex = 0;
  void changeScreen(int screenIndex) {
    setState(() {
      _screenIndex = screenIndex;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Center(
            child: Image.asset(
              'lib/assets/images/champion_yellow.png',
              width: 80,
              height: 80,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        child: Footbar(changeScreen: changeScreen, currentScreen: _screenIndex),
      ),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
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
        return WorkoutsPage();
      case 3:
        return const ProfilePage(key: ValueKey(3));
      default:
        return const SizedBox.shrink();
    }
  }
}
