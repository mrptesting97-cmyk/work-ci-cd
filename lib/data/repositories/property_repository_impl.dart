import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  // In a real app, this would use RemoteDataSource and LocalDataSource
  
  final List<Property> _mockProperties = [
    Property(
      id: '1',
      title: 'Cozy Apartment',
      type: 'Apartment',
      rooms: 2,
      price: 80.0,
      amenities: ['Wi-Fi', 'TV', 'AC'],
      description: 'A very cozy apartment.',
    ),
    Property(
      id: '2',
      title: 'Luxury Villa',
      type: 'Villa',
      rooms: 4,
      price: 350.0,
      amenities: ['Pool', 'Wi-Fi', 'Kitchen'],
      description: 'A beautiful luxury villa.',
    ),
  ];

  @override
  Future<Either<Failure, List<Property>>> getProperties() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return Right(_mockProperties);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch properties'));
    }
  }

  @override
  Future<Either<Failure, void>> addProperty(Property property) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _mockProperties.add(property);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add property'));
    }
  }
}
