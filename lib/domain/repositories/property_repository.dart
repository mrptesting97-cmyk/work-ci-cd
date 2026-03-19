import '../entities/property.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class PropertyRepository {
  Future<Either<Failure, List<Property>>> getProperties();
  Future<Either<Failure, void>> addProperty(Property property);
}
