import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/modules/theme/colors.dart';
import 'package:myapp/modules/api/services/account_service.dart';
import 'package:myapp/modules/providers/UserProvider.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final AccountService _accountService;
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  // Контроллеры для полей
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _cardController = TextEditingController();
  final _additionalPhoneController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _passportSeriesController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _passportPlaceController = TextEditingController();
  final _residencePlaceController = TextEditingController();
  
  DateTime? _birthday;
  DateTime? _passportDate;
  int? _gender; // 1 - мужской, 2 - женский

  @override
  void initState() {
    super.initState();
    _accountService = AccountService(dio);
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final userProvider = context.read<UserProvider>();
    final profile = userProvider.userProfile;
    
    if (profile != null) {
      // Using new UserProfile model fields
      _emailController.text = profile.email ?? '';
      _firstNameController.text = profile.username ?? '';
      // Other fields will be available after CRM sync implementation
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _cardController.dispose();
    _additionalPhoneController.dispose();
    _carNumberController.dispose();
    _passportSeriesController.dispose();
    _passportNumberController.dispose();
    _passportPlaceController.dispose();
    _residencePlaceController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _accountService.updateProfile(
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        firstName: _firstNameController.text.isNotEmpty ? _firstNameController.text : null,
        lastName: _lastNameController.text.isNotEmpty ? _lastNameController.text : null,
        middleName: _middleNameController.text.isNotEmpty ? _middleNameController.text : null,
        card: _cardController.text.isNotEmpty ? _cardController.text : null,
        birthday: _birthday,
        gender: _gender,
        passportSeries: _passportSeriesController.text.isNotEmpty ? _passportSeriesController.text : null,
        passportNumber: _passportNumberController.text.isNotEmpty ? _passportNumberController.text : null,
        passportDate: _passportDate,
        passportPlace: _passportPlaceController.text.isNotEmpty ? _passportPlaceController.text : null,
        residencePlace: _residencePlaceController.text.isNotEmpty ? _residencePlaceController.text : null,
        additionalPhone: _additionalPhoneController.text.isNotEmpty ? _additionalPhoneController.text : null,
        carNumber: _carNumberController.text.isNotEmpty ? _carNumberController.text : null,
      );

      if (!mounted) return;

      // Обновляем данные пользователя
      await context.read<UserProvider>().fetchUser();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Профиль успешно обновлен'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при сохранении: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isBirthday) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthday ? (_birthday ?? DateTime(2000)) : (_passportDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textAlternative,
              surface: AppColors.cardBackground,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isBirthday) {
          _birthday = picked;
        } else {
          _passportDate = picked;
        }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Редактировать профиль',
          style: GoogleFonts.delaGothicOne(
            fontSize: 20.sp,
            color: AppColors.text,
          ),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Сохранить',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16.sp,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Основная информация
              _sectionTitle('Основная информация'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _firstNameController,
                label: 'Имя',
                icon: Icons.person,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _lastNameController,
                label: 'Фамилия',
                icon: Icons.person,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _middleNameController,
                label: 'Отчество',
                icon: Icons.person,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.h),
              _buildDateField(
                label: 'Дата рождения',
                date: _birthday,
                onTap: () => _selectDate(context, true),
              ),
              SizedBox(height: 12.h),
              _buildGenderField(),

              SizedBox(height: 24.h),

              // Контактная информация
              _sectionTitle('Контактная информация'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _additionalPhoneController,
                label: 'Дополнительный телефон',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _residencePlaceController,
                label: 'Адрес проживания',
                icon: Icons.home,
              ),

              SizedBox(height: 24.h),

              // Паспортные данные
              _sectionTitle('Паспортные данные'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _passportSeriesController,
                label: 'Серия паспорта',
                icon: Icons.credit_card,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _passportNumberController,
                label: 'Номер паспорта',
                icon: Icons.credit_card,
              ),
              SizedBox(height: 12.h),
              _buildDateField(
                label: 'Дата выдачи паспорта',
                date: _passportDate,
                onTap: () => _selectDate(context, false),
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _passportPlaceController,
                label: 'Место выдачи паспорта',
                icon: Icons.location_on,
                maxLines: 2,
              ),

              SizedBox(height: 24.h),

              // Дополнительная информация
              _sectionTitle('Дополнительная информация'),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _cardController,
                label: 'Номер карты',
                icon: Icons.credit_card,
              ),
              SizedBox(height: 12.h),
              _buildTextField(
                controller: _carNumberController,
                label: 'Номер автомобиля',
                icon: Icons.directions_car,
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.delaGothicOne(
        fontSize: 18.sp,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: AppColors.text,
          fontSize: 16.sp,
          fontFamily: 'Gilroy',
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.textComplimentary,
            fontFamily: 'Gilroy',
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 4.h),
                  Text(
                    date != null
                        ? '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
                        : 'Не выбрано',
                    style: TextStyle(
                      color: date != null ? AppColors.text : AppColors.textComplimentary,
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textComplimentary, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wc, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 16.w),
              Text(
                'Пол',
                style: TextStyle(
                  color: AppColors.textComplimentary,
                  fontSize: 12.sp,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: RadioListTile<int>(
                  title: Text(
                    'Мужской',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  value: 1,
                  groupValue: _gender,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<int>(
                  title: Text(
                    'Женский',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  value: 2,
                  groupValue: _gender,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
