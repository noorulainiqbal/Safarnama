import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/itinerary_repository.dart';
import '../datasources/itinerary_remote_datasource.dart';
import '../models/schedule_model.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryRemoteDataSource remoteDataSource;

  ItineraryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ScheduleEntity>> getSchedules(String userId) async {
    try {
      final schedules = await remoteDataSource.getSchedules(userId);
      return schedules.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final schedules = await remoteDataSource.getSchedulesByDate(userId, date);
      return schedules.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSchedule(String userId, ScheduleEntity schedule) async {
    try {
      final model = ScheduleModel.fromEntity(schedule);
      await remoteDataSource.addSchedule(userId, model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(String userId, ScheduleEntity schedule) async {
    try {
      final model = ScheduleModel.fromEntity(schedule);
      await remoteDataSource.updateSchedule(userId, model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    try {
      await remoteDataSource.deleteSchedule(userId, scheduleId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ScheduleEntity>> watchSchedules(String userId) {
    return remoteDataSource
        .watchSchedules(userId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }
}
