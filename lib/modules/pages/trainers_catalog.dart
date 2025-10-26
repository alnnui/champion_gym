import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/api/services/trainer_service.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/trainer.dart';
import 'package:myapp/main.dart';
class TrainersCatalogPage extends StatefulWidget {
  const TrainersCatalogPage({super.key});

  @override
  State<TrainersCatalogPage> createState() => _TrainersCatalogPageState();
}

class _TrainersCatalogPageState extends State<TrainersCatalogPage> {
  late final TrainerService _trainerService;
  final List<Trainer> _trainers = [];
  bool _isLoading = true;

  String _searchQuery = '';

  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _trainerService = TrainerService(dio);
    _loadTrainers();
  }
  Future<void> _loadTrainers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      // Using fallback club ID
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;

      final trainers = await _trainerService.getTrainers(clubId);

      setState(() {
        _trainers.clear();
        _trainers.addAll(trainers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки тренеров: $e';
      });
    }
  }
  List<Trainer> get _filteredTrainers {
    return _trainers.where((trainer) {
      final matchesSearch =
          trainer.title.toLowerCase().contains(_searchQuery.toLowerCase());
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
        scrolledUnderElevation: 0,
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
            child: _isLoading 
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                )
              )
            : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.textComplimentary
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 16.sp,
                          fontFamily: 'Gilroy'
                        ),
                        textAlign: TextAlign.center
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _loadTrainers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textAlternative,
                        ),
                        child: Text(
                          'Повторить',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    ]
                  )
                )
              : _filteredTrainers.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64.sp,
                    color: AppColors.textComplimentary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Тренеры не найдены',
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy'
                    )
                  )
                ]
              ),
            ) 
            : ListView.builder(
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
              // Аватар
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.sp,
                    backgroundColor: AppColors.primary,
                    foregroundImage: (trainer.photo != null && trainer.photo!.isNotEmpty)
                      ? NetworkImage(trainer.photo!) 
                      : (trainer.facePhoto != null && trainer.facePhoto!.isNotEmpty)
                        ? NetworkImage(trainer.facePhoto!)
                        : null,
                    child: Text(
                      trainer.title.isNotEmpty 
                        ? trainer.title.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join('').substring(0, 1)
                        : 'T',
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
                          trainer.title,
                          style: GoogleFonts.delaGothicOne(
                            fontSize: 18.sp,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trainer.position ?? 'Тренер',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (trainer.city != null && trainer.city!.isNotEmpty)
                          Text(
                            trainer.city!,
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 12.sp,
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
                          trainer.rating?.toStringAsFixed(1) ?? '0.0',
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
              if ((trainer.biography != null && trainer.biography!.isNotEmpty) || 
                  (trainer.description != null && trainer.description!.isNotEmpty))
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textComplimentary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        trainer.biography ?? trainer.description ?? '',
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              if ((trainer.biography != null && trainer.biography!.isNotEmpty) || 
                  (trainer.description != null && trainer.description!.isNotEmpty))
                SizedBox(height: 12.h),

              // Специализации и возможности
              Row(
                children: [
                  if (trainer.canTrainPersonally == true)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, size: 14.sp, color: AppColors.text),
                          SizedBox(width: 4.w),
                          Text(
                            'Персональные',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (trainer.canTrainPersonally == true && trainer.canTrainGroups == true)
                    SizedBox(width: 8.w),
                  if (trainer.canTrainGroups == true)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundComplimentary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.groups, size: 14.sp, color: AppColors.text),
                          SizedBox(width: 4.w),
                          Text(
                            'Групповые',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (trainer.commentsCount != null && trainer.commentsCount! > 0)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.comment, size: 14.sp, color: AppColors.textComplimentary),
                          SizedBox(width: 4.w),
                          Text(
                            '${trainer.commentsCount}',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 12.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 12.h),

              // Activity types (if available)
              if (trainer.activityTypes.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: trainer.activityTypes.take(3).map((activity) {
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
                        activity.title,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 12.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    );
                  }).toList(),
                ),

              if (trainer.activityTypes.isNotEmpty)
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
                  radius: 30.sp,
                  backgroundColor: AppColors.primary,
                  foregroundImage: (trainer.photo != null && trainer.photo!.isNotEmpty)
                    ? NetworkImage(trainer.photo!) 
                    : (trainer.facePhoto != null && trainer.facePhoto!.isNotEmpty)
                      ? NetworkImage(trainer.facePhoto!)
                      : null,
                  child: Text(
                    trainer.title.isNotEmpty 
                      ? trainer.title.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join('').substring(0, 1)
                      : 'T',
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
                        trainer.title,
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 20.sp,
                          color: AppColors.text,
                        ),
                      ),
                      if (trainer.position != null && trainer.position!.isNotEmpty)
                        Text(
                          trainer.position!,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 14.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      if (trainer.city != null && trainer.city!.isNotEmpty)
                        Text(
                          trainer.city!,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
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

            // Рейтинг и комментарии
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  '${trainer.rating?.toStringAsFixed(1) ?? '0.0'} ${trainer.commentsCount != null ? '(${trainer.commentsCount} отзывов)' : ''}',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Детальные рейтинги
            if (trainer.ratings.isNotEmpty) ...[
              SizedBox(height: 12.h),
              ...trainer.ratings.map((rating) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        rating.parameter.title,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 14.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                    Icon(Icons.star, color: AppColors.primary, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      rating.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14.sp,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' (${rating.votes})',
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              )),
            ],

            SizedBox(height: 16.h),

            // Описание/Биография
            if ((trainer.biography != null && trainer.biography!.isNotEmpty) || 
                (trainer.description != null && trainer.description!.isNotEmpty)) ...[
              Text(
                'О тренере',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                trainer.biography ?? trainer.description ?? '',
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontSize: 14.sp,
                  fontFamily: 'Gilroy',
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Награды
            if (trainer.awards != null && trainer.awards!.isNotEmpty) ...[
              Text(
                'Награды и достижения',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                trainer.awards!,
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontSize: 14.sp,
                  fontFamily: 'Gilroy',
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Информация
            _DetailRow(
              icon: Icons.fitness_center,
              label: 'Типы тренировок',
              value: [
                if (trainer.canTrainPersonally == true) 'Персональные',
                if (trainer.canTrainGroups == true) 'Групповые',
              ].join(', '),
            ),
            if (trainer.phone != null && trainer.phone!.isNotEmpty)
              _DetailRow(
                icon: Icons.phone,
                label: 'Телефон',
                value: trainer.phone!,
              ),

            SizedBox(height: 16.h),

            // Направления (Activity Types)
            if (trainer.activityTypes.isNotEmpty) ...[
              Text(
                'Направления',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: trainer.activityTypes.map((activity) {
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
                      activity.title,
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
            ],

            // Требования (Demands)
            if (trainer.demands.isNotEmpty) ...[
              Text(
                'Специализация',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: trainer.demands.map((demand) {
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
                      demand.title,
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
              SizedBox(height: 16.h),
            ],

            // Социальные сети
            if ((trainer.instagramLink != null && trainer.instagramLink!.isNotEmpty) ||
                (trainer.vkLink != null && trainer.vkLink!.isNotEmpty) ||
                (trainer.facebookLink != null && trainer.facebookLink!.isNotEmpty) ||
                (trainer.telegramLink != null && trainer.telegramLink!.isNotEmpty) ||
                (trainer.whatsAppLink != null && trainer.whatsAppLink!.isNotEmpty)) ...[
              Text(
                'Социальные сети',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (trainer.instagramLink != null && trainer.instagramLink!.isNotEmpty)
                    _SocialButton(
                      icon: Icons.camera_alt,
                      label: 'Instagram',
                      onTap: () {
                        // Open Instagram
                      },
                    ),
                  if (trainer.vkLink != null && trainer.vkLink!.isNotEmpty)
                    _SocialButton(
                      icon: Icons.public,
                      label: 'VK',
                      onTap: () {
                        // Open VK
                      },
                    ),
                  if (trainer.telegramLink != null && trainer.telegramLink!.isNotEmpty)
                    _SocialButton(
                      icon: Icons.send,
                      label: 'Telegram',
                      onTap: () {
                        // Open Telegram
                      },
                    ),
                  if (trainer.whatsAppLink != null && trainer.whatsAppLink!.isNotEmpty)
                    _SocialButton(
                      icon: Icons.message,
                      label: 'WhatsApp',
                      onTap: () {
                        // Open WhatsApp
                      },
                    ),
                ],
              ),
              SizedBox(height: 16.h),
            ],

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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24.sp),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10.sp,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

