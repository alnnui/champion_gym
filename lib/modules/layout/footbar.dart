import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:project_v1/modules/theme/colors.dart';

class Footbar extends StatefulWidget {
  final void Function(int screenIndex) changeScreen;
  const Footbar({super.key, required this.changeScreen});
  @override
  State<Footbar> createState() => _Footbar();
}
class _Footbar extends State<Footbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Center(
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
              ),
            )
          ),
        )),
        Expanded(child: Center(
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
              ),
            )
          ),
        )),
        Expanded(child: Center(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Center(
                    child: Text(
                      'Ваш контент здесь',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                        fontSize: 24
                      )
                    )
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
              ),
            )
          ),
        )),
        Expanded(child: Center(
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
              ),
            )
          ),
        )),
        Expanded(child: Center(
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
              ),
            )
          ),
        )),
      ],
    );
  }
}