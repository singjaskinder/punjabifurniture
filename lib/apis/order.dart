import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:punjabifurniture/models/order_m.dart';
import 'package:punjabifurniture/models/user_m.dart';

abstract class OrderApis {
  Future<void> create(OrderM order);
  Future<void> update(OrderM order);
  Future<void> delete(OrderM order);
  Future<bool> checkTypeId(OrderM order);
  Future<List<UserM>> getUsers();
  Stream<QuerySnapshot> watch(bool isCompleted, String id, bool isAdmin);
  Future<List<String>> validateFiles(List<dynamic> files);
}

class OrderRepo extends OrderApis {
  final _orderStore = FirebaseFirestore.instance.collection('orders');
  final _usersStore = FirebaseFirestore.instance.collection('users');
  final storesStorage = FirebaseStorage.instance.ref().child('orders');

  String randomNumString() => new Random().nextInt(10000000).toString();

  @override
  Future<void> create(OrderM order) async {
    order.id = _orderStore.doc().id;
    await _orderStore.doc(order.id).set(order.toJson());
  }

  @override
  Future<void> update(OrderM order) async {
    await _orderStore.doc(order.id).update(order.toJson());
  }

  @override
  Future<void> delete(OrderM order) async {
    await _orderStore.doc(order.id).delete();
  }

  @override
  Future<bool> checkTypeId(OrderM order) async {
    final res = await _orderStore
        .where('typed_id', isEqualTo: order.typeId)
        .limit(1)
        .get();
    return res.docs.isNotEmpty;
  }

  @override
  Stream<QuerySnapshot> watch(
      bool isCompleted, String id, bool isAdmin) async* {
    late Query query;
    if (id.isEmpty & isAdmin) {
      query = _orderStore
          .where('completed', isEqualTo: isCompleted)
          .orderBy('date', descending: true);
    } else if (id.isNotEmpty && isAdmin) {
      query = _orderStore
          .where('completed', isEqualTo: isCompleted)
          .where('typed_id', isGreaterThanOrEqualTo: id)
          .where('typed_id', isLessThan: id + 'z');
    } else if (id.isNotEmpty && isCompleted && isAdmin) {
      query = _orderStore
          .where('completed', isEqualTo: isCompleted)
          .where('typed_id', isGreaterThanOrEqualTo: id)
          .where('typed_id', isLessThan: id + 'z');
    } else {
      query = _orderStore
          .where('user_id', isEqualTo: id)
          .where('completed', isEqualTo: isCompleted)
          .orderBy('date', descending: true);
    }
    yield* query.snapshots();
  }

  Future<List<UserM>> getUsers() async {
    final data = await _usersStore.orderBy('name').get();
    return data.docs.map((e) => UserM.fromJson(e.data())).toList();
  }

  Future<List<String>> validateFiles(List<dynamic> files) async {
    List<String> links = [];
    await Future.wait(files.map((file) async {
      if (!(file is String)) {
        Uint8List fileBytes = file.bytes;
        String fileName = file.name;
        await FirebaseStorage.instance
            .ref('uploads/$fileName')
            .putData(fileBytes);
        Reference ref =
            storesStorage.child('r' + randomNumString() + '_' + fileName);
        UploadTask uploadTask = ref.putData(fileBytes);
        await uploadTask.then((snapshot) async {
          String url = await snapshot.ref.getDownloadURL();
          links.add(url);
        }).catchError((onError) {
          print(onError);
        });
      } else {
        links.add(file);
      }
    }));
    return links;
  }
}
