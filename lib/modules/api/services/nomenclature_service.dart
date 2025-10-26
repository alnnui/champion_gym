import 'package:dio/dio.dart';
import 'package:myapp/modules/models/nomenclature.dart';

class NomenclatureService {
  final Dio _dio;
  NomenclatureService(this._dio);

  Future<List<NomenclatureType>> getNomenclatureTypes(int clubId) async {
    try {
      print('📡 Fetching nomenclature types for club: $clubId');
      final response = await _dio.get('/club/$clubId/nomenclature/types');
      print('📦 Response status: ${response.statusCode}');
      print('📦 Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Проверяем, не вернулась ли ошибка в формате {status: "error"}
        if (data is Map && data['status'] == 'error') {
          print('❌ API returned error: ${data['message']}');
          throw Exception('API error: ${data['message']}');
        }
        
        if (data is List) {
          print('✅ Received ${data.length} nomenclature types');
          return data
              .whereType<Map<String, dynamic>>()
              .map((e) => NomenclatureType.fromJson(e))
              .toList();
        } else {
          print('❌ Unexpected response format: ${data.runtimeType}');
          print('Response data: $data');
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load nomenclature types: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio exception: ${e.type} - ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Nomenclature request failed: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }
}
