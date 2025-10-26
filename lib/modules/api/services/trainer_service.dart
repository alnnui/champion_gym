import 'package:dio/dio.dart';
import 'package:myapp/modules/models/trainer.dart';

class TrainerService {
  final Dio _dio;
  TrainerService(this._dio);
  Future<List<Trainer>> getTrainers(int clubId) async {
    try {
      final response = await _dio.get("/club/$clubId/trainers.json");
      if (response.statusCode == 200) {
        final List<dynamic> trainersData = response.data;
        return trainersData.map((trainerJson) => Trainer.fromJson(trainerJson)).toList();
      } else {
        throw Exception('Failed to load trainers');
      }
    } catch (e) {
      throw Exception('Error fetching trainers: $e');
    }
  }
}