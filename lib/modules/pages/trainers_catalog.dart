import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Trainer {
  final String name;
  final String specialization;
  final String experience;
  final String education;
  final String phone;
  final String image;
  final double rating;
  final int reviews;
  final List<String> certificates;
  final String description;
  final List<String> specializations;

  Trainer({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.education,
    required this.phone,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.certificates,
    required this.description,
    required this.specializations,
  });
}

class TrainersCatalogPage extends StatefulWidget {
  const TrainersCatalogPage({Key? key}) : super(key: key);

  @override
  State<TrainersCatalogPage> createState() => _TrainersCatalogPageState();
}

class _TrainersCatalogPageState extends State<TrainersCatalogPage> {
  final List<Trainer> _trainers = [
    Trainer(
      name: 'Алексей Петров',
      specialization: 'Силовой тренинг',
      experience: '8 лет',
      education: 'Высшее спортивное образование',
      phone: '+7 (777) 111-22-33',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.9,
      reviews: 89,
      certificates: ['FISAF', 'ACE Personal Trainer', 'CrossFit Level 1'],
      description:
          'Специалист по силовому тренингу с 8-летним опытом работы. Помогает клиентам достигать своих целей в фитнесе.',
      specializations: [
        'Силовой тренинг',
        'Набор мышечной массы',
        'Похудение',
        'Функциональный тренинг',
      ],
    ),
    Trainer(
      name: 'Мария Сидорова',
      specialization: 'Кардио и аэробика',
      experience: '5 лет',
      education: 'Институт физической культуры',
      phone: '+7 (777) 222-33-44',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.7,
      reviews: 156,
      certificates: ['Les Mills', 'Zumba Fitness', 'Pilates Mat'],
      description:
          'Эксперт по кардио тренировкам и групповым занятиям. Создает эффективные программы для похудения.',
      specializations: [
        'Кардио тренировки',
        'Групповые занятия',
        'Похудение',
        'Пилатес',
      ],
    ),
    Trainer(
      name: 'Дмитрий Козлов',
      specialization: 'Йога и растяжка',
      experience: '12 лет',
      education: 'Международная школа йоги',
      phone: '+7 (777) 333-44-55',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.8,
      reviews: 203,
      certificates: ['RYT-200', 'RYT-500', 'Yin Yoga', 'Meditation Teacher'],
      description:
          'Опытный инструктор по йоге с международными сертификатами. Помогает обрести гармонию тела и духа.',
      specializations: ['Хатха йога', 'Виньяса', 'Инь йога', 'Медитация'],
    ),
    Trainer(
      name: 'Анна Иванова',
      specialization: 'Пилатес и реабилитация',
      experience: '6 лет',
      education: 'Медицинский университет',
      phone: '+7 (777) 444-55-66',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.6,
      reviews: 78,
      certificates: [
        'Pilates Mat',
        'Pilates Reformer',
        'Rehabilitation Specialist',
      ],
      description:
          'Специалист по пилатесу и реабилитации. Работает с клиентами после травм и операций.',
      specializations: [
        'Пилатес',
        'Реабилитация',
        'Постуральная коррекция',
        'Пилатес для беременных',
      ],
    ),
    Trainer(
      name: 'Сергей Волков',
      specialization: 'Бокс и единоборства',
      experience: '15 лет',
      education: 'Школа бокса',
      phone: '+7 (777) 555-66-77',
      image: 'lib/assets/images/champion_black.png',
      rating: 4.9,
      reviews: 134,
      certificates: ['Boxing Coach', 'MMA Trainer', 'Self-Defense Instructor'],
      description:
          'Профессиональный тренер по боксу и единоборствам. Бывший чемпион региона.',
      specializations: ['Бокс', 'MMA', 'Самооборона', 'Функциональный тренинг'],
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Все';

  List<Trainer> get _filteredTrainers {
    return _trainers.where((trainer) {
      final matchesSearch =
          trainer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          trainer.specialization.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
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
          'Тренеры',
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
                hintText: 'Поиск тренеров...',
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

          // Список тренеров
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _filteredTrainers.length,
              itemBuilder: (context, index) {
                final trainer = _filteredTrainers[index];
                return _TrainerCard(trainer: trainer);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final Trainer trainer;

  const _TrainerCard({required this.trainer});

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
          _showTrainerDetails(context, trainer);
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
                  // Аватар
                  CircleAvatar(
                    radius: 30.sp,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      trainer.name.split(' ').map((e) => e[0]).join(''),
                      style: TextStyle(
                        color: AppColors.textAlternative,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainer.name,
                          style: GoogleFonts.delaGothicOne(
                            fontSize: 18.sp,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trainer.specialization,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
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
                          trainer.rating.toString(),
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

              SizedBox(height: 12.h),

              // Опыт и образование
              Row(
                children: [
                  Icon(
                    Icons.work,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Опыт: ${trainer.experience}',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.school,
                    color: AppColors.textComplimentary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      trainer.education,
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 14.sp,
                        fontFamily: 'Gilroy',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Специализации
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: trainer.specializations.take(3).map((spec) {
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
                      spec,
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
                        _showTrainerDetails(context, trainer);
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

  void _showTrainerDetails(BuildContext context, Trainer trainer) {
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
                CircleAvatar(
                  radius: 25.sp,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    trainer.name.split(' ').map((e) => e[0]).join(''),
                    style: TextStyle(
                      color: AppColors.textAlternative,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.name,
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 24.sp,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        trainer.specialization,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 16.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColors.textComplimentary),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Рейтинг
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  '${trainer.rating} (${trainer.reviews} отзывов)',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Описание
            Text(
              'О тренере',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              trainer.description,
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 14.sp,
                fontFamily: 'Gilroy',
                height: 1.5,
              ),
            ),

            SizedBox(height: 16.h),

            // Информация
            _DetailRow(
              icon: Icons.work,
              label: 'Опыт',
              value: trainer.experience,
            ),
            _DetailRow(
              icon: Icons.school,
              label: 'Образование',
              value: trainer.education,
            ),
            _DetailRow(
              icon: Icons.phone,
              label: 'Телефон',
              value: trainer.phone,
            ),

            SizedBox(height: 16.h),

            // Специализации
            Text(
              'Специализации',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: trainer.specializations.map((spec) {
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
                    spec,
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

            SizedBox(height: 16.h),

            // Сертификаты
            Text(
              'Сертификаты',
              style: GoogleFonts.delaGothicOne(
                fontSize: 18.sp,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: trainer.certificates.map((cert) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundComplimentary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cert,
                    style: TextStyle(
                      color: AppColors.text,
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
                  // Логика записи к тренеру
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
                  'Записаться к тренеру',
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

