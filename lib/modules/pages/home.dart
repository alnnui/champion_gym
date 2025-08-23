import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_v1/modules/theme/colors.dart';

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
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    );
    final cardTitleStyle = GoogleFonts.delaGothicOne(
      fontSize: 13, 
      fontWeight: FontWeight.w400,
      color: AppColors.text.withAlpha(190)
    );
    final cardTitleStyleAlternative = GoogleFonts.delaGothicOne(
      fontSize: 13, 
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
                          fontSize: 14,
                          letterSpacing: 1,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                      Text('Начнем тренировку?', style: titleStyle),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container( // Полоса прогресса
                      width: screenWidth,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Stack(children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 70,
                              height: 35,
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
                                        fontSize: 14,
                                        letterSpacing: 1
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
                                  fontFamily: 'Gilroy',
                                  fontSize: 20,
                                  letterSpacing: 1,
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'lib/assets/icons/gps.svg',
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: 6),
                                                Text('Кажымукана', style: TextStyle(
                                                  color: AppColors.backgroundComplimentary,
                                                  fontSize: 14,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w400
                                                )),
                                              ]
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'lib/assets/icons/calendar.svg',
                                                  width: 14,
                                                  height: 14,
                                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: 4),
                                                Text('Истекает 14.05.25', style: TextStyle(
                                                  color: AppColors.backgroundComplimentary,
                                                  fontSize: 14,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w400
                                                )),
                                              ]
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'lib/assets/icons/wallet.svg',
                                                  width: 14,
                                                  height: 14,
                                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: 4),
                                                Text('Бизнес', style: TextStyle(
                                                  color: AppColors.backgroundComplimentary,
                                                  fontSize: 14,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w400
                                                )),
                                              ]
                                            ),
                                          ],
                                        )
                                      ],
                                    )
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Посещения', style:cardTitleStyle), 
                                      ],
                                    )
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
                      Row(
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
                      SizedBox(height: 16),
                      Row( // Карточки клубов // пока сделаем 3 потом интегрируем запросы с бэка
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Клуб 1', style: TextStyle(color: Colors.white)),
                              )
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Клуб 2', style: TextStyle(color: Colors.white)),
                              )
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Клуб 3', style: TextStyle(color: Colors.white)),
                              )
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
                      Row(
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
                      SizedBox(height: 16),
                      Row( // Карточки клубов // пока сделаем 3 потом интегрируем запросы с бэка
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Тренер 1', style: TextStyle(color: Colors.white)),
                              )
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Тренер 2', style: TextStyle(color: Colors.white)),
                              )
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: AppColors.backgroundComplimentary
                              ),
                              child: Center(
                                child: Text('Тренер 3', style: TextStyle(color: Colors.white)),
                              )
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
}