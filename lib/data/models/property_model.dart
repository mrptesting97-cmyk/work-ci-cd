import '../../domain/entities/property.dart';

class PropertyModel extends Property {
  PropertyModel({
    required super.id,
    required super.title,
    required super.type,
    required super.rooms,
    required super.price,
    required super.amenities,
    required super.description,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      rooms: json['rooms'],
      price: (json['price'] as num).toDouble(),
      amenities: List<String>.from(json['amenities']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'rooms': rooms,
      'price': price,
      'amenities': amenities,
      'description': description,
    };
  }
}
