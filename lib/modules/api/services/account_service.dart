import 'package:dio/dio.dart';
import 'package:myapp/modules/models/visit_history.dart';
import 'package:myapp/modules/models/schedule_item.dart';
import 'package:myapp/modules/models/service.dart' as service_model;

class AccountService {
  final Dio _dio;

  AccountService(this._dio);

  /// Получает историю посещений пользователя
  /// GET /account/visits/history.json
  Future<List<VisitHistory>> getVisitHistory() async {
    try {
      final response = await _dio.get('/account/visits/history.json');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => VisitHistory.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load visit history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching visit history: $e');
    }
  }

  /// Получает детальную информацию о занятии по ID
  /// GET /schedule/{itemId}/item.json
  Future<ScheduleItem> getScheduleItem(String itemId) async {
    try {
      final response = await _dio.get('/schedule/$itemId/item.json');
      
      if (response.statusCode == 200) {
        return ScheduleItem.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load schedule item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching schedule item: $e');
    }
  }

  /// Обновляет профиль пользователя
  /// POST /account/update.json
  Future<void> updateProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? middleName,
    String? card,
    DateTime? birthday,
    int? gender,
    String? passportSeries,
    String? passportNumber,
    DateTime? passportDate,
    String? passportPlace,
    String? residencePlace,
    String? additionalPhone,
    String? carNumber,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      
      if (email != null) body['email'] = email;
      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (middleName != null) body['middleName'] = middleName;
      if (card != null) body['card'] = card;
      if (birthday != null) body['birthday'] = birthday.toIso8601String().split('T')[0];
      if (gender != null) body['gender'] = gender;
      if (passportSeries != null) body['passportSeries'] = passportSeries;
      if (passportNumber != null) body['passportNumber'] = passportNumber;
      if (passportDate != null) body['passportDate'] = passportDate.toIso8601String().split('T')[0];
      if (passportPlace != null) body['passportPlace'] = passportPlace;
      if (residencePlace != null) body['residencePlace'] = residencePlace;
      if (additionalPhone != null) body['additionalPhone'] = additionalPhone;
      if (carNumber != null) body['carNumber'] = carNumber;

      final response = await _dio.post(
        '/account/update.json',
        data: body,
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  /// Получает список услуг аккаунта (абонементы, тренировки и т.д.)
  /// GET /account/services.json
  Future<List<service_model.AccountService>> getAccountServices() async {
    try {
      final response = await _dio.get('/account/services.json');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return service_model.AccountService.listFromJson(data);
      } else {
        throw Exception('Failed to load account services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching account services: $e');
    }
  }

  /// Получает активный абонемент (Membership)
  /// GET /account/services.json и фильтрует по type = "Membership"
  Future<service_model.AccountService?> getActiveMembership() async {
    try {
      final services = await getAccountServices();
      
      // Ищем активный абонемент типа Membership
      final memberships = services.where((s) => s.isMembership && s.isActive).toList();
      
      if (memberships.isEmpty) return null;
      
      // Возвращаем первый активный абонемент
      return memberships.first;
    } catch (e) {
      throw Exception('Error fetching active membership: $e');
    }
  }

  /// Получает список лицевых счетов (депозитов)
  /// GET /account/deposit.json
  /// Временно возвращает пустой список, так как CRM API не поддерживает этот эндпоинт
  Future<List<Map<String, dynamic>>> getDeposits() async {
    try {
      // TODO: Реализовать когда CRM API добавит поддержку депозитов
      // final response = await _dio.get('/account/deposit.json');
      
      // Временно возвращаем пустой список
      return [];
      
      /*
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load deposits: ${response.statusCode}');
      }
      */
    } catch (e) {
      // Возвращаем пустой список вместо ошибки
      return [];
    }
  }

  /// Получает список операций по лицевому счету
  /// GET /account/deposit/{itemId}.json
  /// Временно возвращает пустой список, так как CRM API не поддерживает этот эндпоинт
  Future<List<Map<String, dynamic>>> getDepositOperations(String itemId) async {
    try {
      // TODO: Реализовать когда CRM API добавит поддержку операций по депозитам
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Получает список всех задолженностей
  /// GET /account/debt/list.json
  Future<List<Map<String, dynamic>>> getDebts() async {
    try {
      final response = await _dio.get('/account/debt/list.json');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load debts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching debts: $e');
    }
  }

  /// Активирует услугу (абонемент)
  /// POST /account/activate/{serviceId}.json
  Future<void> activateService(String serviceId) async {
    try {
      final response = await _dio.post('/account/activate/$serviceId.json');
      
      if (response.statusCode == 200) {
        // Успешно активирована
        return;
      } else {
        throw Exception('Failed to activate service: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error activating service: $e');
    }
  }
}
