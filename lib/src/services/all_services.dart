import 'package:abasu/landing.dart';
import 'package:abasu/src/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AllServices extends ChangeNotifier {
  List<Product> products;

  // Future<List<Product>> fetchProducts() async {
  //   var result = await _api.getDataCollection();
  //
  //   products = result.docs
  //       .map((doc) => Product.fromMap(doc.data, doc.documentID))
  //       .toList();
  //
  //   return products;
  // }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return topProductStreamCollection();
  }

  // Future<Product> getProductById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //
  //   return Product.fromMap(doc.data, doc.documentID);
  // }
  //
  // Future removeProduct(String id) async {
  //   await _api.removeDocument(id);
  //
  //   return;
  // }
  //
  // Future updateProduct(Product data, String id) async {
  //   await _api.updateDocument(data.toJson(), id);
  //
  //   return;
  // }
  //
  // Future addProduct(Product data) async {
  //   var result = await _api.addDocument(data.toJson());
  //
  //   return;
  // }
  Stream<QuerySnapshot> topProductStreamCollection() {
    return root
        .collection('products')
        .where('isTop', isEqualTo: true)
        .snapshots();
  }
}
