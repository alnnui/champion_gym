import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/pages/ai_assistant.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/pages/clubs_catalog.dart';
import 'package:myapp/modules/pages/trainers_catalog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleStyle = GoogleFonts.delaGothicOne(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    );
    final cardTitleStyle = GoogleFonts.delaGothicOne(
      fontSize: 13.sp, 
      fontWeight: FontWeight.w400,
      color: AppColors.text.withAlpha(190)
    );
    final cardTitleStyleAlternative = GoogleFonts.delaGothicOne(
      fontSize: 12.sp, 
      fontWeight: FontWeight.w400,
      color: AppColors.textAlternative
    );

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(0),
      body: SizedBox(
          width: screenWidth,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column( // Приветствие пользователя
                    children: [
                      Text(
                        'Доброе утро, пользователь',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.sp,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                      Text('Начнем тренировку?', style: titleStyle),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container( // Полоса прогресса
                      width: 365.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 78.w,
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'lib/assets/icons/barbell.svg',
                                      width: 36,
                                      height: 36
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '0%',
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontSize: 14.sp,
                                        letterSpacing: 1.sp
                                      )
                                    )
                                  ],
                                )
                              )
                            ),
                          ),
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '70 кг', 
                                style: TextStyle(
                                  fontFamily: 'Benzin',
                                  fontSize: 14.sp,
                                  letterSpacing: 1.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                                )
                              )
                            )
                          )
                        ]
                      )
                    ),
                  SizedBox(height: 32),
                  SizedBox( // Карточки
                    height: screenHeight*0.25,
                    child: Row( // карточки
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                Expanded( // абонемент
                                  child: GestureDetector(
                                    onTap: () => _showMembershipDetails(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text('Абонемент', style:cardTitleStyleAlternative),
                                          SizedBox(height: 6),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow('lib/assets/icons/gps.svg', 'Кажымукана'),
                                              _buildInfoRow('lib/assets/icons/calendar.svg', 'Истекает 14.05.25'),
                                              _buildInfoRow('lib/assets/icons/wallet.svg', 'Бизнес'),
                                            ],
                                          )
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBackground,
                                      borderRadius: BorderRadius.all(Radius.circular(12))
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AIAssistantPage(),
                                          )
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'lib/assets/icons/ai.png',
                                                width: 18.w,
                                                height: 18.h,
                                                color: Colors.yellow,
                                              ),
                                              SizedBox(width: 4),
                                              Text('ИИ Ассистент', style:cardTitleStyle),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Получить совет по питанию и тренировкам',
                                            style: TextStyle(
                                              color: AppColors.textComplimentary,
                                              fontSize: 10.sp,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                )
                              ]
                            )
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Горячее', style:cardTitleStyle)
                              ],
                            )
                          ),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: 24),
                  Column(// Клубы
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClubsCatalogPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Клубы', style: cardTitleStyle),
                            SvgPicture.asset(
                              'lib/assets/icons/next.svg',
                              width: 12,
                              height: 12,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row( // Карточки клубов // пока сделаем 3 потом интегрируем запросы с бэка
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ClubsCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Кажымукана', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('ул. Кажымукана, 8', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ClubsCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Сарыарка', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('Пр. Сарыарка, 5/1', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ClubsCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Другое', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text('Все клубы', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Column(// Тренеры
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrainersCatalogPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Тренеры', style: cardTitleStyle),
                            SvgPicture.asset(
                              'lib/assets/icons/next.svg',
                              width: 12,
                              height: 12,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row( // Карточки тренеров // пока сделаем 3 потом интегрируем запросы с бэка
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TrainersCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColors.primary,
                                      child: Text('А', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Алексей', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Силовые', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TrainersCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColors.primary,
                                      child: Text('М', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Марина', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Фитнес', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TrainersCatalogPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: AppColors.backgroundComplimentary
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppColors.primary,
                                      child: Text('Д', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Дмитрий', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Кроссфит', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.backgroundComplimentary,
                fontSize: 12.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMembershipDetails() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = (screenWidth - 60) / 2; // Same as original card width
        final cardHeight = cardWidth * 1.2; // Maintain aspect ratio
        
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                Text(
                  'Абонемент',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textAlternative,
                  ),
                ),
                SizedBox(height: 6),

                // Детальная информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMembershipInfoRow(
                        'lib/assets/icons/gps.svg',
                        'Клуб',
                        'Кажымукана',
                      ),
                      _buildMembershipInfoRow(
                        'lib/assets/icons/calendar.svg',
                        'Истекает',
                        '14.05.2025',
                      ),
                      _buildMembershipInfoRow(
                        'lib/assets/icons/wallet.svg',
                        'Тип',
                        'Бизнес',
                      ),
                      _buildMembershipInfoRow(
                        'lib/assets/icons/check.svg',
                        'Статус',
                        'Активен',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMembershipInfoRow(String iconPath, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                color: AppColors.backgroundComplimentary,
                fontSize: 12.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}