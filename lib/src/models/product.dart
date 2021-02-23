class Product {
  final String productName;
  final String category;
  final String subCategory;
  final int unitPrice;
  final int availableUnits;
  final String adminId;
  final String productId;
  final String imageUrl;
  final bool approved, isTop;
  final String description;
  final double latitude, longitude;

  Product(
      {this.approved,
      this.availableUnits,
      this.category,
      this.imageUrl = "",
      this.description = "",
      this.longitude,
      this.latitude,
      this.productId,
      this.productName,
      this.unitPrice,
      this.isTop,
      this.subCategory,
      this.adminId});

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'subCategory': subCategory,
      'unitPrice': unitPrice,
      'availableUnits': availableUnits,
      'approved': approved,
      'imageUrl': imageUrl,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'category': category,
      'productId': productId,
      'adminId': adminId,
      'isTop': isTop
    };
  }

  Product.fromFirestore(Map<String, dynamic> firestore)
      : productName = firestore['productName'],
        subCategory = firestore['subCategory'],
        unitPrice = firestore['unitPrice'],
        availableUnits = firestore['availableUnits'],
        approved = firestore['approved'],
        imageUrl = firestore['imageUrl'],
        description = firestore['description'],
        latitude = firestore['latitude'],
        longitude = firestore['longitude'],
        productId = firestore['productId'],
        category = firestore['category'],
        isTop = firestore['isTop'],
        adminId = firestore['adminId'];
}
