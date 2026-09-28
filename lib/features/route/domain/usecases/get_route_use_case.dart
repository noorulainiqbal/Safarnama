import 'package:dartz/dartz.dart';
import '../entities/route_entity.dart';
import '../repository/route_repository.dart';
import '../entities/place_enitity.dart';

class GetRouteUseCase {
  final RouteRepository repository;

  GetRouteUseCase(this.repository);

  Future<Either<String, RouteEntity>> execute({
    required String destination,
    required List<PlaceCategory> categories,
  }) async {
    return await repository.calculateRoute(
      destination: destination,
      selectedCategories: categories,
    );
  }
}
