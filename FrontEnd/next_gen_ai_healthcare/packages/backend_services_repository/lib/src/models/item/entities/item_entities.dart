class ItemEntity {
  final String itemId;
  final String itemName;
  final String description;
  final List<String> images;
  final Map<String, dynamic> location;
  final String seller; 
  final int sold;      
  final double rating; 
  final String userId;
  final int price;
  final bool isRented;
  final int reviews;

  ItemEntity({
    required this.itemId,
    required this.itemName,
    required this.description,
    required this.images,
    required this.location,
    required this.seller,
    required this.sold,
    required this.rating,
    required this.userId, 
    required this.isRented,
    required this.price,
    this.reviews=0,
  });

  static ItemEntity fromJson(Map<String, dynamic> jsonObject) {
    return ItemEntity(
      itemId: jsonObject['_id'] ?? "",
      itemName: jsonObject['itemName'] ?? "",
      description: jsonObject['description'] ?? "",
      images: List<String>.from(jsonObject['images']),
      location: Map<String, dynamic>.from(jsonObject['location']),
      seller: jsonObject['seller'] ?? "",
      sold: jsonObject['sold'] ?? 0, 
      rating: (jsonObject['rating'] as num?)?.toDouble() ?? 0.0,
      userId: jsonObject['userId'] ?? "",
      isRented: jsonObject['isRented']??false,
      price: jsonObject['price'],
      reviews: jsonObject['reviews'] ?? 0,
    );
  }

  static Map<String, dynamic> toJson(ItemEntity itemEntity) {
    return {
      'itemId': itemEntity.itemId,
      'itemName': itemEntity.itemName,
      'description': itemEntity.description,
      'images': itemEntity.images,
      'location': itemEntity.location,
      'seller': itemEntity.seller,
      'sold': itemEntity.sold,     
      'rating': itemEntity.rating, 
      'userId': itemEntity.userId,
      'isRented': itemEntity.isRented,
      'price': itemEntity.price,
      'reviews': itemEntity.reviews,
    };
  }
}
