
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_v1/modules/theme/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/profile.svg',
                      width: 64,
                      height: 64
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Добро пожаловать, Алексей!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ваш клуб: Champion Fitness',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    icon: FontAwesomeIcons.ticket,
                    title: 'Абонемент',
                    children: [
                      _infoRow('Тип', 'Premium'),
                      _infoRow('Срок', 'до 31.12.2025'),
                      _infoRow('Статус', 'Активен'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _sectionCard(
                    icon: FontAwesomeIcons.medal,
                    title: 'Уровень',
                    children: [
                      _infoRow('Текущий уровень', 'Gold'),
                      _infoRow('Баллы', '1200'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _sectionCard(
                    icon: FontAwesomeIcons.building,
                    title: 'Клуб',
                    children: [
                      _infoRow('Название', 'Champion Fitness'),
                      _infoRow('Адрес', 'ул. Спортивная, 10'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _sectionCard(
                    icon: FontAwesomeIcons.userTie,
                    title: 'Тренер',
                    children: [
                      _infoRow('Имя', 'Иван Иванов'),
                      _infoRow('Специализация', 'Силовой тренинг'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.backgroundComplimentary,
            AppColors.backgroundComplimentary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }


  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}