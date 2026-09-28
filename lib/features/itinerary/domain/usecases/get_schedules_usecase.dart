import '../entities/schedule_entity.dart';
import '../repositories/itinerary_repository.dart';

class GetSchedulesUseCase {
  final ItineraryRepository repository;

  GetSchedulesUseCase({required this.repository});

  Future<List<ScheduleEntity>> call(String userId) async {
    return await repository.getSchedules(userId);
  }
}

class GetSchedulesByDateUseCase {
  final ItineraryRepository repository;

  GetSchedulesByDateUseCase({required this.repository});

  Future<List<ScheduleEntity>> call(String userId, DateTime date) async {
    return await repository.getSchedulesByDate(userId, date);
  }
}
