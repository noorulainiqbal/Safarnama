import '../repositories/places_repository.dart';

class SeedPlacesUseCase {
  final PlacesRepository repository;

  SeedPlacesUseCase(this.repository);

  Future<void> call() async {
    return await repository.seedPlaces();
  }
}
