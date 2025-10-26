import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/api/services/club_service.dart';
import 'package:myapp/modules/api/services/trainer_service.dart';
import 'package:myapp/modules/models/club.dart';
import 'package:myapp/modules/models/trainer.dart';
import 'package:myapp/modules/pages/ai_assistant.dart';
import 'package:myapp/modules/pages/promotions_page.dart';
import 'package:myapp/modules/pages/memberships_page.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/modules/pages/clubs_catalog.dart';
import 'package:myapp/modules/pages/trainers_catalog.dart';
import 'package:myapp/modules/widgets/skeleton_loader.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/nomenclature_service.dart';
import 'package:myapp/modules/models/nomenclature.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/models/service.dart' as service_model;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late final ClubService _clubService;
  late final TrainerService _trainerService;
  late final AccountService _accountService;
  final List<Club> _clubs = [];
  final List<Trainer> _trainers = [];
  bool _isLoadingClubs = true;
  bool _isLoadingTrainers = true;
  // Super offer (best SKU) state
  bool _isLoadingHotOffer = true;
  String? _hotOfferError;
  Sku? _bestSku;
  // Membership state
  bool _isLoadingMembership = false;
  service_model.AccountService? _membership;
  // Visit history for progress tracking
  bool _isLoadingVisits = false;
  int _weeklyVisits = 0;
  final int _weeklyGoal = 3; // Цель: 3 тренировки в неделю

  @override
  void initState() {
    super.initState();
    _clubService = ClubService(dio);
    _trainerService = TrainerService(dio);
    _accountService = AccountService(dio);

    // Загружаем данные пользователя сразу при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.userProfile == null) {
        userProvider.fetchUser();
      }
    });

    _loadCubs();
    _loadTrainers();
    _loadHotOffer();
    _loadMembership();
    _loadWeeklyVisits();
  }

  @override
  void dispose() {
    // Очистка ресурсов при удалении виджета
    super.dispose();
  }

  List<Club> _getFallbackClubs() {
    return [
      Club(
        id: 1,
        title: 'Кажымукана',
        address: 'ул. Кажымукана, 8',
        phone: '+7 (123) 456-78-90',
        email: 'kazhymukana@championfitness.kz',
        city: 'Нур-Султан',
        photos: [],
        description: 'Современный фитнес-клуб',
        workingHours: '7:00 - 23:00',
      ),
      Club(
        id: 2,
        title: 'Сарыарка',
        address: 'Пр. Сарыарка, 5/1',
        phone: '+7 (123) 456-78-91',
        email: 'saryarka@championfitness.kz',
        city: 'Нур-Султан',
        photos: [],
        description: 'Современный фитнес-клуб',
        workingHours: '7:00 - 23:00',
      ),
      Club(
        id: 3,
        title: 'Сарыарка',
        address: 'Пр. Сарыарка, 5/1',
        phone: '+7 (123) 456-78-91',
        email: 'saryarka@championfitness.kz',
        city: 'Нур-Султан',
        photos: [],
        description: 'Современный фитнес-клуб',
        workingHours: '7:00 - 23:00',
      ),
    ];
  }

  List<Trainer> _getFallBackTrainers() {
    return [
      Trainer(
        id: 1,
        title: 'Алексей',
        position: 'Силовые тренировки',
        city: 'Нур-Султан',
        description: 'Опытный тренер по силовым тренировкам',
        phone: '+7 (123) 456-78-92',
        canTrainPersonally: true,
        canTrainGroups: true,
      ),
      Trainer(
        id: 2,
        title: 'Марина',
        position: 'Фитнес',
        city: 'Нур-Султан',
        description: 'Профессиональный тренер по фитнесу',
        phone: '+7 (123) 456-78-93',
        canTrainPersonally: true,
        canTrainGroups: true,
      ),
      Trainer(
        id: 3,
        title: 'Дмитрий',
        position: 'Кроссфит',
        city: 'Нур-Султан',
        description: 'Сертифицированный тренер по кроссфиту',
        phone: '+7 (123) 456-78-94',
        canTrainPersonally: true,
        canTrainGroups: true,
      ),
    ];
  }

  Future<void> _loadCubs() async {
    try {
      final clubs = await _clubService.getClubs();

      if (!mounted) return;

      setState(() {
        _clubs.clear();
        _clubs.addAll(clubs);
        _isLoadingClubs = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _clubs.clear();
        _clubs.addAll(_getFallbackClubs());
        _isLoadingClubs = false;
      });
    }
  }

  Future<void> _loadTrainers() async {
    try {
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;

      final trainers = await _trainerService.getTrainers(clubId);

      if (!mounted) return;

      setState(() {
        _trainers.clear();
        _trainers.addAll(trainers);
        _isLoadingTrainers = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _trainers.clear();
        _trainers.addAll(_getFallBackTrainers());
        _isLoadingTrainers = false;
      });
    }
  }

  Future<void> _loadHotOffer() async {
    if (!mounted) return;

    setState(() {
      _isLoadingHotOffer = true;
      _hotOfferError = null;
      _bestSku = null;
    });
    try {
      final service = NomenclatureService(dio);
      // Note: replace 2511 with actual selected club id if available
      final types = await service.getNomenclatureTypes(2511);
      Sku? best;
      for (final t in types) {
        for (final n in t.nomenclatures) {
          for (final s in n.skus) {
            if (s.price != null) {
              if (best == null || (s.price as num) < (best.price as num)) {
                best = s;
              }
            }
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _bestSku = best;
        _isLoadingHotOffer = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hotOfferError = 'Не удалось загрузить супер предложение';
        _isLoadingHotOffer = false;
      });
    }
  }

  Future<void> _loadMembership() async {
    if (!mounted) return;

    setState(() {
      _isLoadingMembership = true;
    });

    try {
      final membership = await _accountService.getActiveMembership();

      if (!mounted) return;

      setState(() {
        _membership = membership;
        _isLoadingMembership = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMembership = false;
      });
      debugPrint('Ошибка загрузки абонемента: $e');
    }
  }

  Future<void> _loadWeeklyVisits() async {
    if (!mounted) return;

    setState(() {
      _isLoadingVisits = true;
    });

    try {
      final history = await _accountService.getVisitHistory();

      if (!mounted) return;

      // Подсчитываем посещения за текущую неделю
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: 7));

      final weeklyVisitsCount = history.where((visit) {
        return visit.startDate.isAfter(weekStart);
      }).length;

      setState(() {
        _weeklyVisits = weeklyVisitsCount;
        _isLoadingVisits = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingVisits = false;
      });
      debugPrint('Ошибка загрузки истории посещений: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleStyle = GoogleFonts.delaGothicOne(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    );
    final cardTitleStyle = GoogleFonts.delaGothicOne(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.text.withAlpha(190),
    );
    final cardTitleStyleAlternative = GoogleFonts.delaGothicOne(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textAlternative,
    );

    // Получаем данные пользователя
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.userProfile;
    final firstName = profile?.username ?? 'пользователь';

    // Определяем время суток для приветствия
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 6) {
      greeting = 'Доброй ночи';
    } else if (hour < 12) {
      greeting = 'Доброе утро';
    } else if (hour < 18) {
      greeting = 'Добрый день';
    } else {
      greeting = 'Добрый вечер';
    }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  // Приветствие пользователя
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $firstName!',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5.sp,
                        color: Color(0xFFC4C4C4),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _membership == null
                          ? 'Давай вначале приобретем абонемент!'
                          : 'Начнем тренировку?',
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                if (_membership != null || _isLoadingMembership)
                  Container(
                    // Полоса прогресса
                    width: 365.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundComplimentary,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: _isLoadingVisits
                                ? 78.w
                                : (365.w * (_weeklyVisits / _weeklyGoal)).clamp(
                                    78.w,
                                    365.w,
                                  ),
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'lib/assets/icons/barbell.svg',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    _isLoadingVisits
                                        ? '...'
                                        : '${((_weeklyVisits / _weeklyGoal) * 100).clamp(0, 100).toInt()}%',
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 14.sp,
                                      letterSpacing: 1.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 0,
                          bottom: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              _isLoadingVisits
                                  ? '...'
                                  : '$_weeklyVisits/$_weeklyGoal тренировок',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 12.sp,
                                letterSpacing: 0.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16.h),
                SizedBox(
                  // Карточки
                  height: 240.h,
                  child: Row(
                    // карточки
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                // абонемент
                                child: GestureDetector(
                                  onTap: _membership != null
                                      ? () => _showMembershipDetails()
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 10.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _membership != null
                                          ? AppColors.primary
                                          : AppColors.backgroundComplimentary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: _isLoadingMembership
                                        ? const MembershipSkeletonContent()
                                        : _membership == null
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MembershipsPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundComplimentary,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Анимированный фон с пульсацией
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          width: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Контент
                                                  Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                12.w,
                                                              ),
                                                          child: Icon(
                                                            Icons.add_card,
                                                            color: AppColors
                                                                .textComplimentary,
                                                            size: 28.sp,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Абонемент\nпросрочен',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .textComplimentary,
                                                            fontSize: 11.sp,
                                                            fontFamily:
                                                                'Gilroy',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.2,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.card_membership,
                                                    color: Colors.black,
                                                    size: 16.sp,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Expanded(
                                                    child: Text(
                                                      'Абонемент',
                                                      style:
                                                          cardTitleStyleAlternative,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6.h),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    _buildInfoRow(
                                                      'lib/assets/icons/wallet.svg',
                                                      _getMembershipType(),
                                                    ),
                                                    _buildInfoRow(
                                                      'lib/assets/icons/calendar.svg',
                                                      _getExpiryDate(),
                                                    ),
                                                    _buildInfoRow(
                                                      'lib/assets/icons/barbell.svg',
                                                      _getDaysLeftLabel(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 10.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AIAssistantPage(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/ai.png',
                                              width: 16.w,
                                              height: 16.h,
                                              color: Colors.yellow,
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                'ИИ Ассистент',
                                                style: cardTitleStyle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        Expanded(
                                          child: Text(
                                            'Получить совет по питанию и тренировкам',
                                            style: TextStyle(
                                              color:
                                                  AppColors.textComplimentary,
                                              fontSize: 10.sp,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w400,
                                              height: 1.3,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PromotionsPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Заголовок с иконкой огня
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Горячее', style: cardTitleStyle),
                                    Container(
                                      padding: EdgeInsets.all(6.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.local_fire_department,
                                        color: AppColors.primary,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),

                                // Разделитель
                                Container(
                                  height: 1,
                                  color: AppColors.backgroundComplimentary
                                      .withOpacity(0.3),
                                ),

                                SizedBox(height: 12.h),

                                // Контент
                                Expanded(
                                  child: _isLoadingHotOffer
                                      ? const HotOfferSkeletonContent()
                                      : _hotOfferError != null
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: AppColors.error,
                                                size: 24.sp,
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                _hotOfferError!,
                                                style: TextStyle(
                                                  color: AppColors.error,
                                                  fontSize: 10.sp,
                                                  fontFamily: 'Gilroy',
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      : _bestSku == null
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.inbox_outlined,
                                                color:
                                                    AppColors.textComplimentary,
                                                size: 28.sp,
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                'Нет предложений',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .textComplimentary,
                                                  fontSize: 11.sp,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Название предложения
                                            Flexible(
                                              child: Text(
                                                _bestSku!.title,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    GoogleFonts.delaGothicOne(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.text,
                                                      height: 1.3,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),

                                            // Цена в плашке
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Цена',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textComplimentary,
                                                      fontSize: 10.sp,
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      _bestSku!.price != null
                                                          ? '${_bestSku!.price} ₸'
                                                          : 'По запросу',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .textComplimentary,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Gilroy',
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Column(
                  // Клубы
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        if (_isLoadingClubs) ...[
                          const ClubSkeletonCard(),
                          const SizedBox(width: 16),
                          const ClubSkeletonCard(),
                          const SizedBox(width: 16),
                          const ClubSkeletonCard(),
                        ] else
                          ..._clubs.take(3).toList().asMap().entries.expand((
                            entry,
                          ) {
                            final index = entry.key;
                            final club = entry.value;
                            final widgets = <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ClubsCatalogPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 140.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                      color: AppColors.backgroundComplimentary,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 12.h,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              club.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                                fontFamily: 'Gilroy',
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Flexible(
                                            child: Text(
                                              club.address,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 10.sp,
                                                fontFamily: 'Gilroy',
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ];
                            if (index < 2) {
                              widgets.add(SizedBox(width: 16));
                            }
                            return widgets;
                          }),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Column(
                  // Тренеры
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      // Карточки тренеров
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_isLoadingTrainers) ...[
                          const TrainerSkeletonCard(),
                          const SizedBox(width: 16),
                          const TrainerSkeletonCard(),
                          const SizedBox(width: 16),
                          const TrainerSkeletonCard(),
                        ] else
                          ..._trainers.take(3).toList().asMap().entries.expand((
                            entry,
                          ) {
                            final index = entry.key;
                            final trainer = entry.value;
                            final widgets = <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TrainersCatalogPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                      color: AppColors.backgroundComplimentary,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                        horizontal: 8.w,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 28.r,
                                            backgroundColor: AppColors.primary,
                                            foregroundImage:
                                                (trainer.photo != null &&
                                                    trainer.photo!.isNotEmpty)
                                                ? NetworkImage(trainer.photo!)
                                                : null,
                                            child: Text(
                                              trainer.title.isNotEmpty
                                                  ? trainer.title[0]
                                                        .toUpperCase()
                                                  : 'T',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            trainer.title.split(' ')[0],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Gilroy',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            trainer.position ??
                                                'Персональный тренер',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10.sp,
                                              fontFamily: 'Gilroy',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ];
                            if (index < 2) {
                              widgets.add(SizedBox(width: 16));
                            }
                            return widgets;
                          }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Вспомогательные методы для получения данных абонемента
  String _getExpiryDate() {
    if (_membership?.endDate != null) {
      final date = _membership!.endDate!;
      return 'Истекает ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year.toString().substring(2)}';
    }
    return 'Не указано';
  }

  String _getMembershipType() {
    return _membership?.title ?? 'Не найден';
  }

  String _getMembershipStatus() {
    return _membership?.status ?? 'Неизвестно';
  }

  String _getDaysLeft() {
    final days = _membership?.daysLeft;
    if (days == null) return '-';
    return '$days';
  }

  String _getDaysLeftLabel() {
    final days = _membership?.daysLeft;
    if (days == null) return 'Срок не указан';
    if (days == 0) return 'Истекает сегодня';
    return '$days дней осталось';
  }

  Widget _buildInfoRow(String iconPath, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 11.w,
            height: 11.h,
            child: SvgPicture.asset(
              iconPath,
              width: 11.w,
              height: 11.h,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.backgroundComplimentary,
                fontSize: 10.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showMembershipDetails() {
    // Получаем данные пользователя в начале метода
    // Using default club name until CRM sync
    final clubName = 'Champion Fitness';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: 320.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundComplimentary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _isLoadingMembership
                ? SizedBox(
                    height: 200.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Заголовок с иконкой
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.card_membership,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Абонемент',
                                  style: GoogleFonts.delaGothicOne(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _getMembershipStatus(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Gilroy',
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Разделитель
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Детальная информация
                      _buildDetailRow(Icons.location_on, 'Клуб', clubName),
                      SizedBox(height: 16.h),

                      _buildDetailRow(
                        Icons.card_giftcard,
                        'Тип абонемента',
                        _getMembershipType(),
                      ),
                      SizedBox(height: 16.h),

                      _buildDetailRow(
                        Icons.calendar_today,
                        'Дата окончания',
                        _membership?.endDate != null
                            ? '${_membership!.endDate!.day.toString().padLeft(2, '0')}.${_membership!.endDate!.month.toString().padLeft(2, '0')}.${_membership!.endDate!.year}'
                            : 'Не указано',
                      ),
                      SizedBox(height: 16.h),

                      _buildDetailRow(
                        Icons.timer,
                        'Осталось дней',
                        _getDaysLeft(),
                      ),

                      SizedBox(height: 24.h),

                      // Кнопка закрытия
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Закрыть',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                            color: AppColors.background,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
