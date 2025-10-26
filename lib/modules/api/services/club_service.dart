import 'package:dio/dio.dart';
import '../../models/club.dart';
import '../../models/activity.dart';
import '../../models/schedule_models.dart';

class ClubService {
  final Dio _dio;
  ClubService(this._dio);
  Future<List<Club>> getClubs() async {
    try {
      final response = await _dio.get(
        "/franchise/clubs.json"
      );
      if (response.statusCode == 200) {
        final List<dynamic> clubsData = response.data;
        return clubsData.map((clubJson) => Club.fromJson(clubJson)).toList();
      } else {
        throw Exception('Failed to load clubs');
      }
    } catch (e) {
      throw Exception('Error fetching clubs: $e');
    }
  }
  
  // Возвращает полную иерархию: Groups с ActivityTypes и Activities
  Future<List<Group>> getActivitiesHierarchy() async {
    try {
      final response = await _dio.get("/franchise/activity-groups.json");
      if (response.statusCode == 200) {
        // Backend возвращает { groups: [...] }
        final groupsData = response.data['groups'] as List<dynamic>;
        
        return groupsData.map((groupJson) {
          return Group.fromJson(groupJson);
        }).toList();
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      throw Exception('Error fetching activities: $e');
    }
  }

  Future<List<Activity>> getActivites() async {
    try {
      final response = await _dio.get("/club/activities");
      if (response.statusCode == 200) {
        final List<dynamic> activitiesData = response.data;
        return activitiesData.map((activityJson) => Activity.fromJson(activityJson)).toList();
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      throw Exception('Error fetching activites: $e');
    }
  }
  Future<ScheduleResponse> getClubSchedule(
    int clubId, {
    int? year,
    int? week,
  }) async {
    try {
      // Формируем query параметры
      final queryParams = <String, dynamic>{};
      if (year != null) {
        queryParams['year'] = year;
      }
      if (week != null) {
        queryParams['week'] = week;
      }
      
      final response = await _dio.get(
        "/club/$clubId/schedule.json",
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      if (response.statusCode == 200) {
        return ScheduleResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load schedule');
      } 
    } catch (e) { 
      throw Exception('Error fetching schedule: $e');
    }
  }

  /// Записывает клиента в лист ожидания на конкретное занятие
  Future<Map<String, dynamic>> reserveActivitySchedule(int scheduleId) async {
    try {
      final response = await _dio.post(
        "/account/waiting-list/reserve.json",
        queryParameters: {'scheduleId': scheduleId},
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to reserve activity');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          // Ошибка валидации
          final errorData = e.response?.data;
          if (errorData != null && errorData is Map) {
            final errors = errorData['errors'] as List?;
            final details = errorData['details'] as List?;
            String errorMessage = 'Ошибка при записи';
            
            if (errors != null && errors.isNotEmpty) {
              errorMessage = errors.join(', ');
            } else if (details != null && details.isNotEmpty) {
              errorMessage = details.join(', ');
            }
            
            throw Exception(errorMessage);
          }
        } else if (e.response?.statusCode == 401) {
          throw Exception('Требуется авторизация');
        }
      }
      throw Exception('Error reserving activity: $e');
    }
  }
}