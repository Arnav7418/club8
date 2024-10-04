import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/experience.dart';

class ExperienceService {
  final Dio _dio;

  ExperienceService(this._dio);

  Future<List<Experience>> fetchExperiences() async {
    try {
      final response = await _dio.get('https://staging.cos.8club.co/experiences');
      final List<dynamic> data = response.data['data']['experiences'];
      return data.map((json) => Experience.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }
}

final dioProvider = Provider((ref) => Dio());

final experienceServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return ExperienceService(dio);
});

final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final experienceService = ref.watch(experienceServiceProvider);
  return experienceService.fetchExperiences();
});
