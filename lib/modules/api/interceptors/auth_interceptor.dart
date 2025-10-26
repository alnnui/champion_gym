import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio;
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Не добавляем токен для эндпоинтов авторизации
    if (options.path.contains('/auth/phone/') || 
        options.path.contains('/auth/refresh') ||
        options.path.contains('/auth/dev/')) {
      return handler.next(options);
    }

    // Читаем токен из secure storage
    final token = await _storage.read(key: _accessTokenKey);
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Если получили 401 (Unauthorized) - пытаемся обновить токен
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      
      if (refreshToken != null) {
        try {
          // Пытаемся обновить access token
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
            options: Options(
              headers: {'Authorization': null}, // Не добавляем старый токен
            ),
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access_token'];
            await _storage.write(key: _accessTokenKey, value: newAccessToken);

            // Повторяем оригинальный запрос с новым токеном
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            
            final cloneReq = await _dio.fetch(opts);
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          // Если не удалось обновить токен - чистим все и редиректим на логин
          await _storage.deleteAll();
          return handler.reject(err);
        }
      }
    }

    return handler.next(err);
  }
}
