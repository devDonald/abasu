import 'package:abasu/landing.dart';
import 'package:abasu/src/construction/products.dart';
import 'package:abasu/src/screens/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConstructionMaterials extends StatefulWidget {
  @override
  _ConstructionMaterialsState createState() => _ConstructionMaterialsState();
}

class _ConstructionMaterialsState extends State<ConstructionMaterials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: materialsRef.orderBy('item', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot snap = snapshot.data.docs[index];
                return ItemsCard(
                  item: snap['item'],
                  icon: Icons.construction,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Products(
                                  subCategory: snap['item'],
                                )));
                  },
                );
              },
            );
          }),
    );
  }
}
