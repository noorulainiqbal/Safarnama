import '../repositories/itinerary_repository.dart';

class DeleteScheduleUseCase {
  final ItineraryRepository repository;

  DeleteScheduleUseCase({required this.repository});

  Future<void> call(String userId, String scheduleId) async {
    return await repository.deleteSchedule(userId, scheduleId);
  }
}
