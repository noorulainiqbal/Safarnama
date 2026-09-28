import '../entities/place_entity.dart';
import '../repositories/places_repository.dart';

class GetRandomPlacesUseCase {
  final PlacesRepository repository;

  GetRandomPlacesUseCase(this.repository);

  Future<List<PlaceEntity>> call(int count) {
    return repository.getRandomPlaces(count);
  }
}
