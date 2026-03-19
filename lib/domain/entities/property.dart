class Property {
  final String id;
  final String title;
  final String type;
  final int rooms;
  final double price;
  final List<String> amenities;
  final String description;

  Property({
    required this.id,
    required this.title,
    required this.type,
    required this.rooms,
    required this.price,
    required this.amenities,
    required this.description,
  });
}
