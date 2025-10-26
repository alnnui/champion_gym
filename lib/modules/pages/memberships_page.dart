import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/api/services/nomenclature_service.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/models/nomenclature.dart';
import 'package:myapp/main.dart';

class MembershipsPage extends StatefulWidget {
  const MembershipsPage({super.key});

  @override
  State<MembershipsPage> createState() => _MembershipsPageState();
}

class _MembershipsPageState extends State<MembershipsPage> {
  bool _loading = true;
  String? _error;
  List<Sku> _memberships = [];
  Sku? _bestMembership;
  String _searchQuery = '';
  bool _isActivating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMemberships();
    });
  }

  Future<void> _fetchMemberships() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;

      print('🔄 Fetching memberships...');
      
      final nomenclatureService = NomenclatureService(dio);
      final types = await nomenclatureService.getNomenclatureTypes(clubId);
      
      print('✅ Received ${types.length} nomenclature types');
      
      // Фильтруем только "Дневные клубные карты"
      List<Sku> memberships = [];
      Sku? best;
      
      for (final type in types) {
        for (final nom in type.nomenclatures) {
          // Проверяем, является ли номенклатура "Дневные клубные карты"
          final isDayMembership = nom.title.toLowerCase().contains('дневн') && 
                                   nom.title.toLowerCase().contains('карт');
          
          if (isDayMembership) {
            for (final sku in nom.skus) {
              memberships.add(sku);
              
              // Находим самый дешевый абонемент
              if (sku.price != null) {
                if (best == null || (sku.price as num) < (best.price as num)) {
                  best = sku;
                }
              }
            }
          }
        }
      }
      
      print('📊 Total memberships found: ${memberships.length}');
      print('⭐ Best membership: ${best?.title ?? "none"} - ${best?.price ?? 0} ₸');
      
      if (!mounted) return;
      setState(() {
        _memberships = memberships;
        _bestMembership = best;
        _loading = false;
      });
    } catch (e, stackTrace) {
      print('❌ Error fetching memberships: $e');
      print('Stack trace: $stackTrace');
      if (!mounted) return;
      setState(() {
        _error = 'Не удалось загрузить абонементы: $e';
        _loading = false;
      });
    }
  }

  List<Sku> get _filteredMemberships {
    if (_searchQuery.trim().isEmpty) {
      return _memberships;
    }
    
    final query = _searchQuery.trim().toLowerCase();
    return _memberships.where((sku) {
      return sku.title.toLowerCase().contains(query) ||
             (sku.description ?? '').toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _activateService(String skuId) async {
    if (!mounted) return;
    
    setState(() {
      _isActivating = true;
    });

    try {
      final accountService = AccountService(dio);
      await accountService.activateService(skuId);
      
      if (!mounted) return;
      
      setState(() {
        _isActivating = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isActivating = false;
      });
      print('❌ Error activating service: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка активации: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
        foregroundColor: AppColors.text,
        title: Text(
          'Абонементы',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Поиск 
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск абонемента...',
                      hintStyle: TextStyle(
                        color: AppColors.textComplimentary,
                        fontFamily: 'Gilroy',
                      ),
                      prefixIcon: Icon(Icons.search, color: AppColors.textComplimentary),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: AppColors.textComplimentary),
                              onPressed: () {
                                if (!mounted) return;
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                    style: TextStyle(color: AppColors.text, fontFamily: 'Gilroy'),
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),

                if (_error != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h, top: 12.h),
                    child: Text(_error!, style: TextStyle(color: AppColors.error, fontFamily: 'Gilroy')),
                  ),

                // Лучшее предложение
                if (_bestMembership != null && _searchQuery.isEmpty) ...[
                  _buildBestOffer(_bestMembership!),
                  SizedBox(height: 24.h),
                ],

                // Заголовок списка
                if (_filteredMemberships.isNotEmpty) ...[
                  Text(
                    'Все абонементы',
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Список абонементов
                if (_filteredMemberships.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.h),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.card_membership,
                            size: 64.sp,
                            color: AppColors.textComplimentary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _searchQuery.isEmpty 
                                ? 'Абонементы не найдены'
                                : 'Нет результатов по запросу',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 16.sp,
                              fontFamily: 'Gilroy',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._filteredMemberships.map((sku) {
                    // Не показываем лучшее предложение в списке, если поиск не активен
                    if (sku.id == _bestMembership?.id && _searchQuery.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return _buildMembershipCard(sku);
                  }),

                SizedBox(height: 24.h),
              ],
            ),
          ),
    );
  }

  Widget _buildBestOffer(Sku sku) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundComplimentary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ЛУЧШЕЕ ПРЕДЛОЖЕНИЕ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Colors.white, size: 20.sp),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            sku.title,
            style: GoogleFonts.delaGothicOne(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          SizedBox(height: 8.h),

          if (sku.description != null && sku.description!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              sku.description!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12.sp,
                fontFamily: 'Gilroy',
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: 12.h),

          Row(
            children: [
              Text(
                'Ваша цена: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy',
                ),
              ),
              Text(
                sku.price != null ? '${sku.price} ₸' : 'Цена по запросу',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOfferFeature(Icons.access_time, 'Без ограничений'),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.fitness_center, 'Все зоны клуба'),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.spa, 'SPA включена'),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              AnimatedTap(
                onTap: () => _showPurchaseDialog(sku),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Купить',
                    style: TextStyle(
                      color: AppColors.backgroundComplimentary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 14.sp),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipCard(Sku sku) {
    return AnimatedTap(
      onTap: () => _showPurchaseDialog(sku),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.backgroundComplimentary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              child: Icon(
                Icons.card_membership,
                color: AppColors.primary,
                size: 28.sp,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sku.title,
                    style: GoogleFonts.delaGothicOne(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  if (sku.description != null && sku.description!.isNotEmpty) ...[
                    Text(
                      sku.description!,
                      style: TextStyle(
                        color: AppColors.textComplimentary,
                        fontSize: 11.sp,
                        fontFamily: 'Gilroy',
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                  ],

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sku.price != null ? '${sku.price} ₸' : 'Цена по запросу',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textComplimentary,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(Sku sku) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Полоска сверху для свайпа
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textComplimentary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),

                      // Большая иконка с градиентом
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.black,
                          size: 50.sp,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Мотивирующий заголовок
                      Text(
                        'Отличный выбор!',
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      // Название абонемента
                      Text(
                        sku.title,
                        style: GoogleFonts.delaGothicOne(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 24.h),

                      // Мотивирующий текст
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Ты на пути к своей лучшей версии!',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Каждая тренировка приближает тебя к цели. Этот абонемент — твой билет в мир здоровья, энергии и уверенности. Не откладывай свои мечты на потом!',
                              style: TextStyle(
                                color: AppColors.textComplimentary,
                                fontSize: 14.sp,
                                fontFamily: 'Gilroy',
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Преимущества
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundComplimentary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Что тебя ждет:',
                              style: GoogleFonts.delaGothicOne(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildBenefit(Icons.fitness_center, 'Современные тренажеры и оборудование'),
                            SizedBox(height: 12.h),
                            _buildBenefit(Icons.people, 'Поддержка опытных тренеров'),
                            SizedBox(height: 12.h),
                            _buildBenefit(Icons.schedule, 'Гибкий график тренировок'),
                            SizedBox(height: 12.h),
                            _buildBenefit(Icons.spa, 'Доступ к зонам отдыха'),
                            SizedBox(height: 12.h),
                            _buildBenefit(Icons.group, 'Мотивирующая атмосфера'),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Цена
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withAlpha(100),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Стоимость: ',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              sku.price != null ? '${sku.price} ₸' : 'Уточняйте',
                              style: GoogleFonts.delaGothicOne(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Призыв к действию
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Инвестируй в себя сегодня — получи результат завтра!',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 13.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),

              // Кнопки внизу
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Основная кнопка
                      AnimatedTap(
                        onTap: _isActivating ? null : () {
                          Navigator.of(context).pop();
                          _activateService(sku.id);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _isActivating
                            ? SizedBox(
                                height: 24.h,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  color: Colors.black,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Начать тренироваться!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Кнопка отмены
                      AnimatedTap(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Text(
                            'Посмотреть другие варианты',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
