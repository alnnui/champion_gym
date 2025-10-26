import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DebtListPage extends StatefulWidget {
  final String? depositId;
  final String? depositName;

  const DebtListPage({
    super.key,
    this.depositId,
    this.depositName,
  });

  @override
  State<DebtListPage> createState() => _DebtListPageState();
}

class _DebtListPageState extends State<DebtListPage> {
  late final AccountService _accountService;
  List<Map<String, dynamic>> _debts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    _loadDebts();
  }

  Future<void> _loadDebts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final allDebts = await _accountService.getDebts();
      
      if (!mounted) return;
      
      // Фильтруем задолженности по depositId, если он указан
      List<Map<String, dynamic>> filteredDebts = allDebts;
      if (widget.depositId != null) {
        filteredDebts = allDebts.where((debt) {
          final depositAccount = debt['depositAccount'];
          if (depositAccount != null && depositAccount is Map) {
            return depositAccount['id']?.toString() == widget.depositId;
          }
          return false;
        }).toList();
      }
      
      setState(() {
        _debts = filteredDebts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = 'Не удалось загрузить задолженности';
        _isLoading = false;
      });
      debugPrint('Ошибка загрузки задолженностей: $e');
    }
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'Не указано';
    
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.textComplimentary;
    
    final s = status.toLowerCase();
    if (s.contains('paid') || s.contains('оплачен')) {
      return AppColors.success;
    } else if (s.contains('pending') || s.contains('ожидание')) {
      return AppColors.primary;
    } else if (s.contains('overdue') || s.contains('просрочен')) {
      return AppColors.error;
    }
    return AppColors.textComplimentary;
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
        title: Column(
          children: [
            Text(
              'Задолженности',
              style: GoogleFonts.delaGothicOne(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
            if (widget.depositName != null) ...[
              SizedBox(height: 2.h),
              Text(
                widget.depositName!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textComplimentary,
                  fontFamily: 'Gilroy',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: AppColors.textComplimentary,
                            fontSize: 16.sp,
                            fontFamily: 'Gilroy',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: _loadDebts,
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
              : _debts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.circleCheck,
                            size: 64.sp,
                            color: AppColors.success,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Задолженностей нет',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 18.sp,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'У вас нет активных задолженностей',
                            style: TextStyle(
                              color: AppColors.textComplimentary,
                              fontSize: 14.sp,
                              fontFamily: 'Gilroy',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadDebts,
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _debts.length,
                        itemBuilder: (context, index) {
                          final debt = _debts[index];
                          final id = debt['id']?.toString() ?? '';
                          final time = debt['time']?.toString();
                          final operation = debt['operation']?.toString() ?? 'Задолженность';
                          final cost = debt['cost'];
                          final entityId = debt['entityId']?.toString();
                          final hook = debt['hook'];
                          final depositAccount = debt['depositAccount'];
                          
                          final costValue = cost is num ? cost : (cost is String ? num.tryParse(cost) : null);
                          
                          String? hookStatus;
                          String? hookMessage;
                          if (hook != null && hook is Map) {
                            hookStatus = hook['status']?.toString();
                            hookMessage = hook['message']?.toString();
                          }
                          
                          String? depositName;
                          if (depositAccount != null && depositAccount is Map) {
                            depositName = depositAccount['name']?.toString();
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.error.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.error.withOpacity(0.1),
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
                                      // Иконка задолженности
                                      Container(
                                        width: 48.w,
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.exclamationTriangle,
                                          color: AppColors.error,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      // Информация о задолженности
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              operation,
                                              style: TextStyle(
                                                color: AppColors.text,
                                                fontSize: 15.sp,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            if (time != null)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 12.sp,
                                                    color: AppColors.textComplimentary,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    _formatDateTime(time),
                                                    style: TextStyle(
                                                      color: AppColors.textComplimentary,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Gilroy',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      // Сумма задолженности
                                      if (costValue != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${costValue.abs().toStringAsFixed(0)} ₸',
                                              style: TextStyle(
                                                color: AppColors.error,
                                                fontSize: 18.sp,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  
                                  // Статус и сообщение
                                  if (hookStatus != null || hookMessage != null) ...[
                                    SizedBox(height: 12.h),
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundComplimentary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hookStatus != null)
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(hookStatus).withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    hookStatus,
                                                    style: TextStyle(
                                                      color: _getStatusColor(hookStatus),
                                                      fontSize: 11.sp,
                                                      fontFamily: 'Gilroy',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (hookMessage != null) ...[
                                            if (hookStatus != null) SizedBox(height: 8.h),
                                            Text(
                                              hookMessage,
                                              style: TextStyle(
                                                color: AppColors.text,
                                                fontSize: 13.sp,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                  
                                  // Информация о лицевом счете
                                  if (depositName != null) ...[
                                    SizedBox(height: 12.h),
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.wallet,
                                            size: 14.sp,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Лицевой счет',
                                                  style: TextStyle(
                                                    color: AppColors.textComplimentary,
                                                    fontSize: 11.sp,
                                                    fontFamily: 'Gilroy',
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  depositName,
                                                  style: TextStyle(
                                                    color: AppColors.text,
                                                    fontSize: 13.sp,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  
                                  // ID и Entity ID
                                  if (id.isNotEmpty || entityId != null) ...[
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        if (id.isNotEmpty) ...[
                                          Icon(
                                            Icons.tag,
                                            size: 12.sp,
                                            color: AppColors.textComplimentary,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'ID: $id',
                                            style: TextStyle(
                                              color: AppColors.textComplimentary,
                                              fontSize: 11.sp,
                                              fontFamily: 'Courier',
                                            ),
                                          ),
                                        ],
                                        if (id.isNotEmpty && entityId != null)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                                            child: Text('•', style: TextStyle(color: AppColors.textComplimentary)),
                                          ),
                                        if (entityId != null)
                                          Text(
                                            'Entity: $entityId',
                                            style: TextStyle(
                                              color: AppColors.textComplimentary,
                                              fontSize: 11.sp,
                                              fontFamily: 'Courier',
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
