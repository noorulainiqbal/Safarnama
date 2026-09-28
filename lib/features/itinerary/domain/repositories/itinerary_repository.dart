import '../entities/schedule_entity.dart';

abstract class ItineraryRepository {
  Future<List<ScheduleEntity>> getSchedules(String userId);
  Future<List<ScheduleEntity>> getSchedulesByDate(String userId, DateTime date);
  Future<void> addSchedule(String userId, ScheduleEntity schedule);
  Future<void> updateSchedule(String userId, ScheduleEntity schedule);
  Future<void> deleteSchedule(String userId, String scheduleId);
  Stream<List<ScheduleEntity>> watchSchedules(String userId);
}
