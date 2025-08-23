import 'package:flutter/material.dart';
import 'package:project_v1/modules/theme/colors.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            /// Верхние карточки с основными метриками
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Калории",
                      value: "1850 ккал",
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: "Калории",
                      value: "1850 ккал",
                      color: AppColors.success,
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: 24),
            // Нижние карточки с метриками
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Калории",
                      value: "1850 ккал",
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: "Калории",
                      value: "1850 ккал",
                      color: AppColors.success,
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Row(children: [
                  Expanded(
                    child: _StatCard(
                      title: "Доп. плитка",
                      value: "1212 Кал",
                      color: AppColors.primary,
                    ),
                  )
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
