import 'package:flutter/material.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/main.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DepositOperationsPage extends StatefulWidget {
  final String depositId;
  final String depositName;

  const DepositOperationsPage({
    super.key,
    required this.depositId,
    required this.depositName,
  });

  @override
  State<DepositOperationsPage> createState() => _DepositOperationsPageState();
}

class _DepositOperationsPageState extends State<DepositOperationsPage> {
  late final AccountService _accountService;
  List<Map<String, dynamic>> _operations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    _loadOperations();
  }

  Future<void> _loadOperations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final operations = await _accountService.getDepositOperations(widget.depositId);
      
      if (!mounted) return;
      
      setState(() {
        _operations = operations;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = 'Не удалось загрузить операции';
        _isLoading = false;
      });
      debugPrint('Ошибка загрузки операций: $e');
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

  IconData _getOperationIcon(String? operation) {
    if (operation == null) return FontAwesomeIcons.circleNotch;
    
    final op = operation.toLowerCase();
    if (op.contains('пополнение') || op.contains('начисление')) {
      return FontAwesomeIcons.arrowDown;
    } else if (op.contains('списание') || op.contains('покупка')) {
      return FontAwesomeIcons.arrowUp;
    }
    return FontAwesomeIcons.circleNotch;
  }

  Color _getOperationColor(num? cost) {
    if (cost == null) return AppColors.textComplimentary;
    if (cost > 0) return AppColors.success;
    if (cost < 0) return AppColors.error;
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
              'Операции по счету',
              style: GoogleFonts.delaGothicOne(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              widget.depositName,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textComplimentary,
                fontFamily: 'Gilroy',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
                        onPressed: _loadOperations,
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
              : _operations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.receipt,
                            size: 64.sp,
                            color: AppColors.textComplimentary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Операций пока нет',
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
                      onRefresh: _loadOperations,
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: _operations.length,
                        itemBuilder: (context, index) {
                          final operation = _operations[index];
                          final id = operation['id']?.toString() ?? '';
                          final time = operation['time']?.toString();
                          final operationType = operation['operation']?.toString() ?? 'Операция';
                          final cost = operation['cost'];
                          
                          final costValue = cost is num ? cost : (cost is String ? num.tryParse(cost) : null);
                          final operationColor = _getOperationColor(costValue);
                          final operationIcon = _getOperationIcon(operationType);

                          return Container(
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
                              child: Row(
                                children: [
                                  // Иконка операции
                                  Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: operationColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      operationIcon,
                                      color: operationColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  // Информация об операции
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          operationType,
                                          style: TextStyle(
                                            color: AppColors.text,
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
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
                                        if (id.isNotEmpty) ...[
                                          SizedBox(height: 4.h),
                                          Text(
                                            'ID: $id',
                                            style: TextStyle(
                                              color: AppColors.textComplimentary,
                                              fontSize: 11.sp,
                                              fontFamily: 'Courier',
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  // Сумма операции
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        costValue != null 
                                            ? '${costValue > 0 ? '+' : ''}${costValue.toStringAsFixed(0)} ₸'
                                            : '0 ₸',
                                        style: TextStyle(
                                          color: operationColor,
                                          fontSize: 18.sp,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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
