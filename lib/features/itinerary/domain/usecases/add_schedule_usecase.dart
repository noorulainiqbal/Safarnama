import '../entities/schedule_entity.dart';
import '../repositories/itinerary_repository.dart';

class AddScheduleUseCase {
  final ItineraryRepository repository;

  AddScheduleUseCase({required this.repository});

  Future<void> call(String userId, ScheduleEntity schedule) async {
    return await repository.addSchedule(userId, schedule);
  }
}
