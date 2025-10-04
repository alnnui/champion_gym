import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Club {
  final String name;
  final String address;
  final String phone;
  final String workingHours;
  final String image;
  final double rating;
  final List<String> amenities;
  final String description;

  Club({
    required this.name,
    required this.address,
    required this.phone,
    required this.workingHours,
    required this.image,
    required this.rating,
    required this.amenities,
    required this.description,
  });
}

class ClubsCatalogPage extends StatefulWidget {
  const ClubsCatalogPage({Key? key}) : super(key: key);

  @override
  State<ClubsCatalogPage> createState() => _ClubsCatalogPageState();
}

class _ClubsCatalogPageState extends State<ClubsCatalogPage> {
  final List<Club> _clubs = [
    Club(
      name: 'Champion Business',
      address: 'ул. Кажымукана, 8',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00-23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
    Club(
      name: 'Champion Business',
      address: 'Проспект Сарыарка, 5/1',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.9,
      amenities:['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
    Club(
      name: 'Champion Business',
      address: 'Проспект Туран, 50',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.9,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',),
    Club(
      name: 'Champion Business',
      address: 'Улица Кайым Мухамедханов, 21',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
        Club(
      name: 'Champion Business',
      address: 'Улица Кайым Мухамедханов, 21',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
        Club(
      name: 'Champion Business',
      address: 'Улица Кайым Мухамедханов, 21',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
        Club(
      name: 'Champion Business',
      address: 'Улица Магжана Жумабаева, 25/1',
      phone: '+7 (702)-369-30-30',
      workingHours: '7:00 - 23:00',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      amenities: ['Тренажерный зал', 'Сауна', 'Массаж', "Фитнес-бар", "Кроссфит", 'Фитнес для детей','Персональный тренер'],
      description:
          'Современный фитнес-клуб с полным набором услуг для настоящих чемпионов.',
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Все';

  List<Club> get _filteredClubs {
    return _clubs.where((club) {
      final matchesSearch =
          club.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          club.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Клубы',
          style: GoogleFonts.delaGothicOne(
            fontSize: 20.sp,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск клубов...',
                hintStyle: TextStyle(
                  color: AppColors.textComplimentary,
                  fontFamily: 'Gilroy',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textComplimentary,
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Список клубов
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _filteredClubs.length,
              itemBuilder: (context, index) {
                final club = _filteredClubs[index];
                return _ClubCard(club: club);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Club club;

  const _ClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () {
          _showClubDetails(context, club);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и рейтинг
              Row(
                children: [
                  Expanded(
                    child: Text(
                      club.name,
                      style: GoogleFonts.delaGothicOne(
                        fontSize: 18.sp,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: AppColors.primary, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          club.rating.toString(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Адрес
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      club.address,
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 14.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Часы работы
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    club.workingHours,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Удобства
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: club.amenities.take(3).map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundComplimentary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      amenity,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 12.h),

              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Звонок
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textAlternative,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.phone, size: 16.sp),
                      label: Text(
                        'Позвонить',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Подробнее
                        _showClubDetails(context, club);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.info_outline, size: 16.sp),
                      label: Text(
                        'Подробнее',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClubDetails(BuildContext context, Club club) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                Expanded(
                  child: Text(
                    club.name,
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 24.sp,
                      color: AppColors.text,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColors.textComplimentary),
                ),
              ],
            ),

            SizedBox(height: 16.h),




            SizedBox(height: 16.h),

            // Описание
            Text(
              'Описание',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              club.description,
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
                height: 1.5,
              ),
            ),

            SizedBox(height: 16.h),

            // Контактная информация
            _DetailRow(
              icon: Icons.location_on,
              label: 'Адрес',
              value: club.address,
            ),
            _DetailRow(icon: Icons.phone, label: 'Телефон', value: club.phone),
            _DetailRow(
              icon: Icons.access_time,
              label: 'Часы работы',
              value: club.workingHours,
            ),

            SizedBox(height: 16.h),

            // Удобства
            Text(
              'Удобства',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: club.amenities.map((amenity) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    amenity,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24.h),

            // Кнопка записи
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Логика записи в клуб
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textAlternative,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Записаться в клуб',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textComplimentary, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 12.sp,
                    fontFamily: 'Gilroy',
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

