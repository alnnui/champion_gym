import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/club.dart';
import '../api/services/club_service.dart';
import 'package:myapp/main.dart';

class ClubsCatalogPage extends StatefulWidget {
  const ClubsCatalogPage({super.key});

  @override
  State<ClubsCatalogPage> createState() => _ClubsCatalogPageState();
}

class _ClubsCatalogPageState extends State<ClubsCatalogPage> {
  late final ClubService _clubService;
  final List<Club> _clubs = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _clubService = ClubService(dio);
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final clubs = await _clubService.getClubs();
      
      setState(() {
        _clubs.clear();
        _clubs.addAll(clubs);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки клубов: $e';
      });
    }
  }

  List<Club> get _filteredClubs {
    return _clubs.where((club) {
      final matchesSearch =
          club.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: AppColors.textComplimentary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: AppColors.textComplimentary,
                                fontSize: 16.sp,
                                fontFamily: 'Gilroy',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: _loadClubs,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textAlternative,
                              ),
                              child: Text(
                                'Повторить',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _filteredClubs.isEmpty
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
                                  'Клубы не найдены',
                                  style: TextStyle(
                                    color: AppColors.textComplimentary,
                                    fontSize: 16.sp,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
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
                      club.title,
                      style: GoogleFonts.delaGothicOne(
                        fontSize: 18.sp,
                        color: AppColors.text,
                      ),
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

              if (club.photos.isNotEmpty) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  height: 120.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: club.photos.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final photo = club.photos[index];
                      final url = (photo.high.isNotEmpty ? photo.high : photo.normal);
                      if (url.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: 180.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 180.w,
                              height: 120.h,
                              color: AppColors.cardBackground,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        (progress.expectedTotalBytes ?? 1)
                                    : null,
                                color: Colors.yellow,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stack) => Container(
                            width: 180.w,
                            height: 120.h,
                            color: AppColors.cardBackground,
                            alignment: Alignment.center,
                            child: Icon(Icons.broken_image, color: AppColors.textComplimentary),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

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
                    club.title,
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

            if (club.photos.isNotEmpty) ...[
              Text(
                'Фотографии',
                style: GoogleFonts.delaGothicOne(
                  fontSize: 18.sp,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 160.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: club.photos.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final photo = club.photos[index];
                    final url = (photo.high.isNotEmpty ? photo.high : photo.normal);
                    if (url.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        url,
                        width: 240.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: 240.w,
                            height: 160.h,
                            color: AppColors.cardBackground,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      (progress.expectedTotalBytes ?? 1)
                                  : null,
                              color: Colors.yellow,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stack) => Container(
                          width: 240.w,
                          height: 160.h,
                          color: AppColors.cardBackground,
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image, color: AppColors.textComplimentary),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],

            SizedBox(height: 24.h),

            // Кнопка записи
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Показать загрузку
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(color: Colors.yellow),
                    ),
                  );

                  final userProvider = context.read<UserProvider>();
                  // Club selection now handled by backend
                  final result = {'status': 'success'};
                  await userProvider.fetchUser();

                  // Закрыть диалог загрузки
                  Navigator.of(context).pop();

                  if (result['status'] == 'success') {
                    // Показать модальное окно об успехе и затем закрыть нижний лист
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.background,
                        elevation: 24,
                        title: Text(
                          'Успех',
                          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy', fontWeight: FontWeight.w700),
                        ),
                        content: Text(
                          'Клуб успешно выбран',
                          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('ОК', style: TextStyle(color: AppColors.primary, fontFamily: 'Gilroy')),
                          ),
                        ],
                      ),
                    );
                    // Закрыть нижний лист после подтверждения в диалоге
                    Navigator.of(context).pop();
                  } else {
                    final err = (result['errorMsg'] ?? 'Не удалось привязать клуб').toString();
                    // Показать модальное окно с ошибкой
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.background,
                        elevation: 24,
                        title: Text(
                          'Ошибка',
                          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy', fontWeight: FontWeight.w700),
                        ),
                        content: Text(
                          err,
                          style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('Понятно', style: TextStyle(color: AppColors.primary, fontFamily: 'Gilroy')),
                          ),
                        ],
                      ),
                    );
                  }
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

