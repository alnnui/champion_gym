import 'package:dio/dio.dart';
import 'package:myapp/modules/models/user_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthService(this._dio);

  // НОВЫЙ МЕТОД: Запрос SMS через наш FastAPI бэкенд
  Future<Map<String, dynamic>> requestSms(String phoneNumber) async {
    // Форматируем номер телефона
    String rawPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (rawPhone.length < 10) {
      return {
        "status": "error",
        "errorMsg": 'Введите корректный номер (10 цифр)'
      };
    }
    
    String last10 = rawPhone.substring(rawPhone.length - 10);
    String formattedPhone = '7$last10';

    try {
      final response = await _dio.post(
        '/auth/phone/request-sms',
        data: {'phone': formattedPhone},
      );
      
      if (response.statusCode == 200) {
        return {"status": "success"};
      } else {
        return {
          "status": "error",
          "errorMsg": response.data['detail'] ?? 'Ошибка: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      return {
        "status": "error",
        "errorMsg": e.response?.data['detail'] ?? 'Ошибка запроса: $e'
      };
    }
  }

  // НОВЫЙ МЕТОД: Подтверждение SMS кода и получение JWT токенов
  Future<Map<String, dynamic>> confirmPasswordFromSms(String phone, String code) async {
    // Форматируем телефон
    String rawPhone = phone.replaceAll(RegExp(r'\D'), '');
    String last10 = rawPhone.substring(rawPhone.length - 10);
    String formattedPhone = '7$last10';

    try {
      final response = await _dio.post(
        '/auth/phone/authorize',
        data: {
          'phone': formattedPhone,
          'sms_code': code,
        },
      );
      
      if (response.statusCode == 200) {
        // Сохраняем JWT токены
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];
        
        await saveTokens(accessToken, refreshToken);
        
        return {
          "status": "success",
          "access_token": accessToken,
          "refresh_token": refreshToken,
        };
      } else {
        return {
          "status": "error",
          "errorMsg": response.data['detail'] ?? 'Ошибка: ${response.statusCode}'
        };
      }
    } on DioException catch (e) {
      return {
        "status": "error",
        "errorMsg": e.response?.data['detail'] ?? 'Ошибка запроса: $e'
      };
    }
  }

  // НОВЫЙ МЕТОД: Получение профиля пользователя с нашего бэкенда
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching user profile: ${e.message}');
    }
  }

  // Сохранение конфигурации Rive-аватара на бэкенде
  Future<UserProfile> updateAvatarConfig(Map<String, dynamic> config) async {
    try {
      final response = await _dio.patch(
        '/user/avatar',
        data: {'avatar_config': config},
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to update avatar: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error updating avatar: ${e.message}');
    }
  }

  // НОВЫЙ МЕТОД: Синхронизация с CRM
  Future<UserProfile> syncWithCrm() async {
    try {
      final response = await _dio.post('/crm/sync');
      
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to sync with CRM: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error syncing with CRM: ${e.message}');
    }
  }

  // НОВЫЙ МЕТОД: Обновление токена
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await _storage.write(key: _accessTokenKey, value: newAccessToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  // JWT Token Management (используем flutter_secure_storage)
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
} 