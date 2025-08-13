import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_v1/modules/components/animated_button.dart';
import 'package:project_v1/modules/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
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
      bottomNavigationBar: BottomAppBar(
        color: AppColors.backgroundComplimentary,
        child: SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/champion.svg',
                      width: 32,
                      height: 32,
                    ),
                    Text('Главная', style: footbarCardTitleStyle),
                  ]
                ),
              )),
              Expanded(
                child: SizedBox(
                  width: 48,
                  height: 56,
                  child: Container(
                    color: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SvgPicture.asset(
                        'lib/assets/icons/statistic.svg',
                        width: 24,
                        height: 24
                      )
                    )
                  )
                )
              ),
              Expanded(child: Center(
                child: AnimatedButton(
                  width: 56,
                  height: 56,
                  backgroundColor: AppColors.primary,
                  onPressed: () {

                  },
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  borderRadius: 12,
                  child: Center(
                    child: SvgPicture.asset(
                      'lib/assets/icons/card.svg',
                      width: 32,
                      height: 32,
                    ),
                  )
                ),
              )),
              Expanded(child: Center(
                child: Text('Тренировки', style: footbarCardTitleStyle),
              )),
              Expanded(child: Center(
                child: Text('Профиль', style: footbarCardTitleStyle),
              )),
            ],
          )
        ), 
      ),
    );
  }
}