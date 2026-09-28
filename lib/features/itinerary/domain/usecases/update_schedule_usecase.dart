import '../entities/schedule_entity.dart';
import '../repositories/itinerary_repository.dart';

class UpdateScheduleUseCase {
  final ItineraryRepository repository;

  UpdateScheduleUseCase({required this.repository});

  Future<void> call(String userId, ScheduleEntity schedule) async {
    return await repository.updateSchedule(userId, schedule);
  }
}
