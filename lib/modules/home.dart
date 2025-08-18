import 'package:flutter/material.dart';
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
                SizedBox(width: screenWidth, height: 32),
                SizedBox(
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
                                          Text('Кажымукана', style: TextStyle(
                                            color: AppColors.backgroundComplimentary,
                                            fontSize: 14,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w400
                                          )),
                                          Text('Истекает 25.04.25', style: TextStyle(
                                            color: AppColors.backgroundComplimentary,
                                            fontSize: 14,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w400
                                          )),
                                          Text('Бизнес', style: TextStyle(
                                            color: AppColors.backgroundComplimentary,
                                            fontSize: 14,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w400
                                          )),
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
              ],
            ),
          ),
      ),
    );
  }
}