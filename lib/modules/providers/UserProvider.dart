import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/modules/api/services/auth_service.dart';
import 'package:myapp/modules/models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService;

  UserProvider(Dio dio) : _authService = AuthService(dio);

  UserProfile? _userProfile;
  bool _loading = false;
  bool _syncing = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _loading;
  bool get isSyncing => _syncing;
  bool get isLoggedIn => _userProfile != null;
  String? get error => _error;

  // Загрузка профиля пользователя с нашего бэкенда
  Future<void> fetchUser() async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      final profile = await _authService.getUserProfile();
      _userProfile = profile;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _userProfile = null;
      if (kDebugMode) print('Ошибка загрузки пользователя: $e');
    }
    
    _loading = false;
    notifyListeners();
  }
  
  // НОВЫЙ МЕТОД: Синхронизация с CRM
  Future<void> syncWithCRM() async {
    _syncing = true;
    _error = null;
    notifyListeners();
    
    try {
      final profile = await _authService.syncWithCrm();
      _userProfile = profile;
      _error = null;
      if (kDebugMode) print('Синхронизация с CRM завершена успешно');
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('Ошибка синхронизации с CRM: $e');
    }
    
    _syncing = false;
    notifyListeners();
  }
  
  // Очистка при логауте
  Future<void> logout() async {
    await _authService.deleteTokens();
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
  
  // Обновить часть данных (локально)
  void updateUser(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  // Сохранение конфигурации аватара на бэкенде с обновлением кэша
  Future<void> updateAvatarConfig(Map<String, dynamic> config) async {
    final updated = await _authService.updateAvatarConfig(config);
    _userProfile = updated;
    _error = null;
    notifyListeners();
  }
}
