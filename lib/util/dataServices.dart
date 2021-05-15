import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DataBaseService {
  final String uid;
  DataBaseService({this.uid});
  int i = 1;
  final CollectionReference cart = Firestore.instance.collection('cart');
  final CollectionReference orders = Firestore.instance.collection('orders');
  final CollectionReference users = Firestore.instance.collection('users');
  Future<dynamic> usersList(String name, String phno, String address,String outerAddress,String token,List loc,String map) async {
     await users.document(uid).setData({
      'fullName': name,
      'phoneNumber': phno,
      'address': address,
      'outerAddress':outerAddress,
      'token':token,
      'coords':loc,
      'mapAddress':map,
    }, merge: true).then((value) => value).catchError((e)=>print(e.toString()));
  }

  Future useritems(String id,Map data) async {
    return await cart.document(uid).setData({
      id:data
    }, merge: true);
  }
  Future deleteItem(id) async {
    return await cart.document(uid).updateData({id: FieldValue.delete()});
  }
  Future updateRecentWeight(id,weight) async {
    return await cart.document(uid).setData({id: {'recentWeight':weight}},merge:true);
  }
  Future deleteWeight(id,weight) async {
    return await cart.document(uid).setData({id:{'weights':{weight:FieldValue.delete()},'recentWeight':FieldValue.delete()}},merge:true);
  }
  Future updateCount(id,count) async {
    return await cart.document(uid).setData({id:{'count':count}},merge:true);
  }
  Future updateWeightCount(id,weight,count) async {
    return await cart.document(uid).setData({id:{'weights':{weight:{'count':count}}}},merge:true);
  }

  Future ordersList(Map order) async {
    if (await orders.document('001').get().then((value) {
      if (value.exists) {
        return false;
      } else {
        return true;
      }
    })) {
      return await orders.document('001').setData(order);
    } else {
      // ignore: missing_return
      var orderid = await orders
          .orderBy('time', descending: true)
          .limit(1)
          .getDocuments()
          // ignore: missing_return
          .then((value) {
        List documents = value.documents;
        for (DocumentSnapshot i in documents) {
          return int.parse(i.documentID) + 1;
        }
      });
      return await orders.document(orderid.toString()).setData(order);
    }
  }
}
