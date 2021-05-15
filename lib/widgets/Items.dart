import 'package:cloud_firestore/cloud_firestore.dart';

List cate = [
  {'type': 1, 'name': 'Bakery Products', 'image': 'images/bakery.jpg'},
  {'type': 2, 'name': 'Branded Foods', 'image': 'images/brandedfood.jpg'},
  {'type': 3, 'name': 'Dairy Products', 'image': 'images/dairy.jpg'},
  {'type': 4, 'name': 'Fruits', 'image': 'images/fruits.jpg'},
  {'type': 5, 'name': 'Non-Veg Products', 'image': 'images/nonveg.jpg'},
  {'type': 6, 'name': 'Snacks', 'image': 'images/Snacks.jpg'},
  {'type': 7, 'name': 'Vegetables', 'image': 'images/vegetables.jpg'},
];

DocumentSnapshot lcart;
