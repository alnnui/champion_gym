import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/pages/deposit_operations_page.dart';
import 'package:myapp/modules/pages/debt_list_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DepositsPage extends StatefulWidget {
  const DepositsPage({super.key});

  @override
  State<DepositsPage> createState() => _DepositsPageState();
}

class _DepositsPageState extends State<DepositsPage> {
  late final AccountService _accountService;
  List<Map<String, dynamic>> _deposits = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    _loadDeposits();
  }

  Future<void> _loadDeposits() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final deposits = await _accountService.getDeposits();
      
      if (!mounted) return;
      
      setState(() {
        _deposits = deposits;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = 'Не удалось загрузить лицевые счета';
        _isLoading = false;
      });
      debugPrint('Ошибка загрузки депозитов: $e');
    }
  }

  String _getDepositTypeLabel(String? type) {
    if (type == null) return 'Общий';
    
    switch (type.toLowerCase()) {
      case 'personal':
        return 'Личный';
      case 'corporate':
        return 'Корпоративный';
      case 'bonus':
        return 'Бонусный';
      default:
        return type;
    }
  }

  IconData _getDepositIcon(String? type) {
    if (type == null) return FontAwesomeIcons.wallet;
    
    switch (type.toLowerCase()) {
      case 'personal':
        return FontAwesomeIcons.user;
      case 'corporate':
        return FontAwesomeIcons.building;
      case 'bonus':
        return FontAwesomeIcons.gift;
      default:
        return FontAwesomeIcons.wallet;
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
          'Лицевые счета',
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: AppColors.textComplimentary,
                          fontSize: 16.sp,
                          fontFamily: 'Gilroy',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: _loadDeposits,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textAlternative,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Повторить',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _deposits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.wallet,
                            size: 64.sp,
                            color: AppColors.textComplimentary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'У вас пока нет лицевых счетов',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 16.sp,
                              fontFamily: 'Gilroy',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadDeposits,
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _deposits.length,
                        itemBuilder: (context, index) {
                          final deposit = _deposits[index];
                          final name = deposit['name']?.toString() ?? 'Счёт ${index + 1}';
                          final type = deposit['type']?.toString();
                          final balance = deposit['balance'] ?? 0;
                          final entityId = deposit['entityId']?.toString() ?? '';
                          final id = deposit['id']?.toString() ?? '';

                          return GestureDetector(
                            onTap: () {
                              if (id.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepositOperationsPage(
                                      depositId: id,
                                      depositName: name,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 48.w,
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _getDepositIcon(type),
                                          color: AppColors.primary,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                color: AppColors.text,
                                                fontSize: 16.sp,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              _getDepositTypeLabel(type),
                                              style: TextStyle(
                                                color: AppColors.textComplimentary,
                                                fontSize: 13.sp,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundComplimentary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Баланс',
                                                style: TextStyle(
                                                  color: AppColors.textComplimentary,
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Gilroy',
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                '$balance ₸',
                                                style: TextStyle(
                                                  color: balance > 0 
                                                      ? AppColors.success 
                                                      : AppColors.text,
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (id.isNotEmpty)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'ID: $id',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 11.sp,
                                                fontFamily: 'Courier',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  // Индикатор нажатия
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Посмотреть операции',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13.sp,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.primary,
                                        size: 14.sp,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  // Кнопка задолженностей
                                  GestureDetector(
                                    onTap: () {
                                      if (id.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DebtListPage(
                                              depositId: id,
                                              depositName: name,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.error,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.exclamationTriangle,
                                            color: AppColors.error,
                                            size: 12.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Задолженности',
                                            style: TextStyle(
                                              color: AppColors.error,
                                              fontSize: 13.sp,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.error,
                                            size: 12.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (entityId.isNotEmpty) ...[
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.tag,
                                          size: 14.sp,
                                          color: AppColors.textComplimentary,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'Entity: $entityId',
                                          style: TextStyle(
                                            color: AppColors.textComplimentary,
                                            fontSize: 12.sp,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
