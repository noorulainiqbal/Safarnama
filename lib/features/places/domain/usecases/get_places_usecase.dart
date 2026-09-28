import '../entities/place_entity.dart';
import '../repositories/places_repository.dart';

class GetPlacesUseCase {
  final PlacesRepository repository;

  GetPlacesUseCase(this.repository);

  Future<List<PlaceEntity>> call() async {
    return await repository.getPlaces();
  }
}
