import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/modules/components/animated_button.dart';
import 'package:myapp/modules/theme/colors.dart';

class Footbar extends StatefulWidget {
  final void Function(int screenIndex) changeScreen;
  final int currentScreen;
  const Footbar({
    super.key,
    required this.changeScreen,
    required this.currentScreen,
  });
  @override
  State<Footbar> createState() => _Footbar();
}

class _Footbar extends State<Footbar> {
  @override
  Widget build(BuildContext context) {
    ColorFilter? getColorFilter(int index) {
      return widget.currentScreen == index
          ? const ColorFilter.mode(Colors.yellow, BlendMode.srcIn)
          : null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(0);
              },
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/home.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(1);
              },
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/statistic.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(1),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 48,
              height: 48,
              backgroundColor: AppColors.primary,
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.6,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ваш штрихкод',
                            style: TextStyle(
                              color: AppColors.text,
                              fontFamily: 'Gilroy',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),

                          // Убран визуальный штрихкод, оставлен только текст
                          SizedBox(height: 24),
                          Text(
                            'Покажите этот штрихкод на входе в клуб для быстрого прохода',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/card.svg',
                  width: 20,
                  height: 20,
                  colorFilter: getColorFilter(
                    4,
                  ), // не подсвечивается, если нужно - поменяйте индекс
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(2);
              },
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/workout.svg',
                  width: 24,
                  height: 24,
                  colorFilter: getColorFilter(2),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedButton(
              width: 56,
              height: 56,
              backgroundColor: Colors.black.withAlpha(0),
              onPressed: () {
                widget.changeScreen(3);
              },
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              borderRadius: 12,
              child: Center(
                child: SvgPicture.asset(
                  'lib/assets/icons/profile.svg',
                  width: 28,
                  height: 28,
                  colorFilter: getColorFilter(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
