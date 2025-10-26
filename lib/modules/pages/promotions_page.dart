import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/components/animated_tap.dart';
import 'package:myapp/modules/api/services/nomenclature_service.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/models/nomenclature.dart';
import 'package:myapp/modules/models/service.dart' as service_model;
import 'package:myapp/main.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  bool _loading = true;
  String? _error;
  List<NomenclatureType> _types = const [];
  List<service_model.AccountService> _myServices = const [];
  Sku? _bestSku;
  String _searchQuery = '';
  NomenclatureType? _selectedType;
  Nomenclature? _selectedNomenclature;
  int currentScreenId = 1;

  void changeSreenOfPromotions(screenId) {
    if (!mounted) return;
    setState(() {
      currentScreenId = screenId;
    });
  }

  bool _skuMatchesSelection(Sku sku) {
    // If a type is selected, ensure sku is inside that type
    if (_selectedType != null) {
      final foundInType = _selectedType!.nomenclatures.any((n) => n.skus.any((s) => s.id == sku.id));
      if (!foundInType) return false;
    }
    // If a specific nomenclature is selected, ensure sku is inside it
    if (_selectedNomenclature != null) {
      final foundInNom = _selectedNomenclature!.skus.any((s) => s.id == sku.id);
      if (!foundInNom) return false;
    }
    return true;
  }

  // Проверка, приобретена ли уже услуга с таким названием
  bool _isServiceAlreadyPurchased(String skuTitle) {
    return _myServices.any((service) => 
      service.title?.toLowerCase().trim() == skuTitle.toLowerCase().trim()
    );
  }

  @override
  void initState() {
    super.initState();
    // Defer fetching until after first frame so `context` and providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Using fallback club ID
      final int fallbackClubId = 2511;
      final int clubId = fallbackClubId;

      print('🔄 Starting to fetch promotions data...');
      
      final nomenclatureService = NomenclatureService(dio);
      final accountService = AccountService(dio);
      
      // Загружаем и акции, и мои услуги параллельно
      print('📡 Fetching nomenclature types and account services...');
      final results = await Future.wait([
        nomenclatureService.getNomenclatureTypes(clubId),
        accountService.getAccountServices(),
      ]);
      
      final types = results[0] as List<NomenclatureType>;
      final services = results[1] as List<service_model.AccountService>;
      
      print('✅ Received ${types.length} nomenclature types');
      print('✅ Received ${services.length} account services');
      
      // Find best (lowest price) SKU
      Sku? best;
      int skuCount = 0;
      for (final t in types) {
        print('  Type: ${t.title} (${t.nomenclatures.length} nomenclatures)');
        for (final n in t.nomenclatures) {
          print('    Nomenclature: ${n.title} (${n.skus.length} skus)');
          for (final s in n.skus) {
            skuCount++;
            if (s.price != null) {
              print('      SKU: ${s.title} - ${s.price} ₸');
              if (best == null || (s.price as num) < (best.price as num)) {
                best = s;
              }
            }
          }
        }
      }
      
      print('📊 Total SKUs found: $skuCount');
      print('⭐ Best SKU: ${best?.title ?? "none"} - ${best?.price ?? 0} ₸');
      
      if (!mounted) return;
      setState(() {
        _types = types;
        _myServices = services;
        _bestSku = best;
        _loading = false;
      });
    } catch (e, stackTrace) {
      print('❌ Error fetching promotions: $e');
      print('Stack trace: $stackTrace');
      if (!mounted) return;
      setState(() {
        _error = 'Не удалось загрузить предложения: $e';
        _loading = false;
      });
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
          'Акции и предложения',
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
          color: AppColors.primary
        ),
      )
      : SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор между страницами (Мои услуги / Все акции и предложения)
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedTap(
                            onTap: () => changeSreenOfPromotions(1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: currentScreenId == 2 ? AppColors.backgroundComplimentary : AppColors.primary,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              padding: EdgeInsets.all(12.h),
                              child: Center(
                                child: Text(
                                  'Мои услуги',
                                  style: TextStyle(
                                    color: currentScreenId == 2 ? AppColors.textComplimentary : AppColors.textAlternative,
                                    fontFamily: 'Gilroy',
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: AnimatedTap(
                            onTap: () => changeSreenOfPromotions(2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: currentScreenId == 1 ? AppColors.backgroundComplimentary : AppColors.primary,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              padding: EdgeInsets.all(12.h),
                              child: Center(
                                child: Text(
                                  'Все акции',
                                  style: TextStyle(
                                    color: currentScreenId == 1 ? AppColors.textComplimentary : AppColors.textAlternative,
                                    fontFamily: 'Gilroy',
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
            SizedBox(height: 16.h),

            // Отображаем либо "Мои услуги", либо "Все акции"
            if (currentScreenId == 1) 
              _buildMyServicesScreen()
            else
              _buildAllPromotionsScreen(),
          ],
        ),
      ),
    );
  }

  // Экран "Мои услуги"
  Widget _buildMyServicesScreen() {
    if (_myServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Icon(
              Icons.inventory_2_outlined,
              size: 64.sp,
              color: AppColors.textComplimentary,
            ),
            SizedBox(height: 16.h),
            Text(
              'У вас пока нет активных услуг',
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 16.sp,
                fontFamily: 'Gilroy',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Активные услуги',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 12.h),
        ..._myServices.map((service) => _buildServiceCard(service)),
      ],
    );
  }

  // Экран "Все акции"
  Widget _buildAllPromotionsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Поиск 
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск предложений...',
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
        
        // Types (горизонтальный список типов номенклатур)
        if (_types.isNotEmpty) ...[
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _types.map((type) {
                final isSelected = _selectedType?.id == type.id;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        if (isSelected) {
                          _selectedType = null;
                          _selectedNomenclature = null;
                        } else {
                          _selectedType = type;
                          _selectedNomenclature = null;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.textComplimentary),
                      ),
                      child: Text(
                        type.title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected ? AppColors.textAlternative : AppColors.text,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        // Nomenclatures (второй уровень) — показываем, если выбран тип
        if (_selectedType != null && _selectedType!.nomenclatures.isNotEmpty) ...[
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedType!.nomenclatures.map((nom) {
                final isSelected = _selectedNomenclature?.id == nom.id;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        _selectedNomenclature = isSelected ? null : nom;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.textComplimentary),
                      ),
                      child: Text(
                        nom.title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected ? AppColors.textAlternative : AppColors.text,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, top: 12.h),
            child: Text(_error!, style: TextStyle(color: AppColors.error, fontFamily: 'Gilroy')),
          ),

        if (_bestSku != null) SizedBox(height: 16.h),
        // Выгодный абонемент (самая низкая цена)
        if (_bestSku != null) _buildSpecialOffer(),
        if (_bestSku != null) SizedBox(height: 16.h),

        if (_types.isNotEmpty) ...[
          Text(
            'Предложения клуба',
            style: GoogleFonts.delaGothicOne(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12.h),
          _buildSwipeableOffers(),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }

  Widget _buildServiceCard(service_model.AccountService service) {
    final isActive = service.isActive;
    
    // Определяем цвет в зависимости от статуса
    Color statusColor;
    String statusText;
    if (isActive) {
      statusColor = AppColors.success;
      statusText = 'Активна';
    } else if (service.status == 'Suspended') {
      statusColor = Colors.orange;
      statusText = 'Приостановлена';
    } else {
      statusColor = AppColors.textComplimentary;
      statusText = service.status ?? 'Неизвестно';
    }

    // Форматирование даты
    String formatDate(DateTime? date) {
      if (date == null) return '—';
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.backgroundComplimentary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и статус
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title ?? 'Услуга',
                      style: GoogleFonts.delaGothicOne(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                    if (service.typeService != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        service.typeService!,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 13.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: statusColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Информация в виде простых строк
          if (service.balance != null && service.balance! > 0)
            _buildInfoRow(
              label: 'Баланс',
              value: service.initialBalance != null 
                ? '${service.balance} / ${service.initialBalance}'
                : '${service.balance}',
            ),

          if (service.countReserves != null && service.countReserves! > 0)
            _buildInfoRow(
              label: 'Забронировано',
              value: '${service.countReserves}',
            ),

          if (service.trainerName != null && service.trainerName!.isNotEmpty)
            _buildInfoRow(
              label: 'Тренер',
              value: service.trainerName!,
            ),

          _buildInfoRow(
            label: 'Действует до',
            value: formatDate(service.endDate),
            trailing: service.daysLeft != null
                ? Text(
                    '${service.daysLeft} дн.',
                    style: TextStyle(
                      color: service.daysLeft! < 7 ? AppColors.error : AppColors.text,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                  )
                : null,
          ),

          // Автопродление
          if (service.recurrent == true && service.recurrentSettings != null) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.autorenew,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Автопродление',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (service.recurrentSettings!.nextDate != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            'Списание: ${formatDate(service.recurrentSettings!.nextDate)}',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 11.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                        if (service.recurrentSettings!.price?.amount != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            '${service.recurrentSettings!.price!.amount} ${service.recurrentSettings!.price!.currency?.symbol ?? '₸'}',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 11.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (service.recurrentSettings!.canBeCanceled == true)
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.textComplimentary, size: 20.sp),
                      onPressed: () {
                        _showCancelRecurrentDialog(service);
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontSize: 13.sp,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: trailing ?? Text(
              value,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 13.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelRecurrentDialog(service_model.AccountService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Отменить автопродление?',
          style: GoogleFonts.delaGothicOne(
            fontSize: 18.sp,
            color: AppColors.text,
          ),
        ),
        content: Text(
          'Вы уверены, что хотите отменить автоматическое продление услуги "${service.title}"?',
          style: TextStyle(
            color: AppColors.textComplimentary,
            fontSize: 14.sp,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.textComplimentary,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Автопродление отменено'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Отменить',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableOffers() {
    final offers = <Widget>[];
    
    for (final type in _types) {
      for (final nom in type.nomenclatures) {
        for (final sku in nom.skus) {
          if (_bestSku != null && sku.id == _bestSku!.id) continue;
          if (!_skuMatchesSelection(sku)) continue;
          
          final query = _searchQuery.trim().toLowerCase();
          if (query.isNotEmpty) {
            final matches = sku.title.toLowerCase().contains(query) ||
              (sku.description ?? '').toLowerCase().contains(query) ||
              nom.title.toLowerCase().contains(query) ||
              type.title.toLowerCase().contains(query);
            if (!matches) continue;
          }

          offers.add(_buildPromotionCard(
            sku: sku,
            title: sku.title,
            description: sku.description ?? (sku.restrictions?.workTime?.plainText ?? 'Без описания'),
            discount: sku.price != null ? '${sku.price} ₸' : 'Цена по запросу',
            validUntil: '—',
            icon: Icons.local_offer,
          ));
        }
      }
    }
    
    if (offers.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: Text(
            'Нет доступных предложений',
            style: TextStyle(color: AppColors.textComplimentary, fontFamily: 'Gilroy'),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180.h,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: offers[index],
          );
        },
      ),
    );
  }

  

  Widget _buildSpecialOffer() {
    final sku = _bestSku;
    if (sku == null) return const SizedBox.shrink();
    // Respect selected filters: if special SKU is outside selection, hide it
    if (!_skuMatchesSelection(sku)) return const SizedBox.shrink();
    // Если есть поисковый запрос — показываем супер-предложение только если оно совпадает
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final matches = sku.title.toLowerCase().contains(query) ||
          (sku.description ?? '').toLowerCase().contains(query);
      if (!matches) return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundComplimentary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.03),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
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
                  'СУПЕР ПРЕДЛОЖЕНИЕ',
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
            ),
          ],

          SizedBox(height: 8.h),

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
                    _buildOfferFeature(
                      Icons.access_time,
                      'Без ограничений по времени',
                    ),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.fitness_center, 'Все зоны клуба'),
                    SizedBox(height: 4.h),
                    _buildOfferFeature(Icons.spa, 'SPA и сауна включены'),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              AnimatedTap(
                onTap: () => _showPurchaseDialog(sku),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
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

  Widget _buildPromotionCard({
    required Sku sku,
    required String title,
    required String description,
    required String discount,
    required String validUntil,
    required IconData icon,
  }) {
    final isAlreadyPurchased = _isServiceAlreadyPurchased(title);
    
    return AnimatedTap(
      onTap: isAlreadyPurchased ? null : () => _showPurchaseDialog(sku),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAlreadyPurchased 
                ? AppColors.success.withOpacity(0.3)
                : AppColors.backgroundComplimentary, 
            width: 1
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24.sp),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.delaGothicOne(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          if (isAlreadyPurchased) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20.sp,
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 12.sp,
                          fontFamily: 'Gilroy',
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8.h),

                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              discount,
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Text(
                            'До $validUntil',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 10.sp,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog([Sku? sku]) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Иконка
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: AppColors.primary,
                    size: 32.sp,
                  ),
                ),

                SizedBox(height: 16.h),

                // Заголовок
                Text(
                  sku?.title ?? 'Покупка',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 8.h),

                // Цена
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sku?.price != null ? '${sku!.price} ₸' : 'Цена по запросу',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Описание
                if (sku?.description != null) ...[
                  Text(
                    sku!.description!,
                    style: TextStyle(
                      color: AppColors.textComplimentary,
                      fontSize: 13.sp,
                      fontFamily: 'Gilroy',
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20.h),
                ],

                // Кнопки
                Row(
                  children: [
                    Expanded(
                      child: AnimatedTap(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundComplimentary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textComplimentary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Отмена',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AnimatedTap(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showPaymentForm(sku);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Купить',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textAlternative,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPaymentForm([Sku? sku]) {
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();
    final cardHolderController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.background,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок с логотипом Kaspi
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Kaspi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Visa',
                        style: TextStyle(
                          color: Color(0xFF1A1F71),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.textComplimentary),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Информация о покупке
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundComplimentary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'К оплате',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 12.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                sku?.title ?? 'Покупка',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gilroy',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              sku?.price != null ? '${sku!.price} ₸' : '0 ₸',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Форма оплаты
                  Text(
                    'Данные карты',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Номер карты
                  _buildPaymentField(
                    controller: cardNumberController,
                    label: 'Номер карты',
                    hint: '0000 0000 0000 0000',
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    prefixIcon: Icons.credit_card,
                  ),

                  SizedBox(height: 16.h),

                  // Срок действия и CVV
                  Row(
                    children: [
                      Expanded(
                        child: _buildPaymentField(
                          controller: expiryDateController,
                          label: 'Срок действия',
                          hint: 'MM/YY',
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          prefixIcon: Icons.calendar_today,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildPaymentField(
                          controller: cvvController,
                          label: 'CVV',
                          hint: '000',
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Имя держателя карты
                  _buildPaymentField(
                    controller: cardHolderController,
                    label: 'Имя держателя карты',
                    hint: 'IVAN IVANOV',
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    prefixIcon: Icons.person_outline,
                  ),

                  SizedBox(height: 24.h),

                  // Информация о безопасности
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: AppColors.success,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Ваши данные защищены и не передаются третьим лицам',
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 11.sp,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Кнопка оплаты
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedTap(
                      onTap: () {
                        // Валидация (можно добавить позже)
                        Navigator.of(dialogContext).pop();
                        _showPaymentSuccess(sku);
                        
                        // Очистка контроллеров
                        cardNumberController.dispose();
                        expiryDateController.dispose();
                        cvvController.dispose();
                        cardHolderController.dispose();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Оплатить ${sku?.price != null ? "${sku!.price} ₸" : ""}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textAlternative,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Кнопка отмены
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedTap(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        
                        // Очистка контроллеров
                        cardNumberController.dispose();
                        expiryDateController.dispose();
                        cvvController.dispose();
                        cardHolderController.dispose();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.textComplimentary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Отмена',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    int? maxLength,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textComplimentary,
              fontFamily: 'Gilroy',
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.textComplimentary,
              size: 20.sp,
            ),
            filled: true,
            fillColor: AppColors.backgroundComplimentary,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }

  void _showPaymentSuccess([Sku? sku]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Иконка успеха
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 48.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                // Заголовок
                Text(
                  'Оплата успешна!',
                  style: GoogleFonts.delaGothicOne(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Описание
                Text(
                  'Ваша покупка "${sku?.title ?? "услуга"}" успешно оформлена',
                  style: TextStyle(
                    color: AppColors.textComplimentary,
                    fontSize: 14.sp,
                    fontFamily: 'Gilroy',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Кнопка
                SizedBox(
                  width: double.infinity,
                  child: AnimatedTap(
                    onTap: () {
                      Navigator.of(context).pop();
                      _fetchData(); // Обновляем список услуг
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Отлично!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textAlternative,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                        ),
                      ),
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
}
