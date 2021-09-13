import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:punjabifurniture/models/user_m.dart';

abstract class UserApis {
  Future<void> create(UserM user);
  Future<void> update(UserM user);
  Future<void> delete(UserM user);
  Stream<QuerySnapshot> watch(String name);
}

class UserRepo extends UserApis {
  final _userStore = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> create(UserM user) async {
    await _userStore.doc(user.id).set(user.toJson());
  }
  
  @override
  Future<void> update(UserM user) async {
    await _userStore.doc(user.id).update(user.toJson());
  }

  @override
  Future<void> delete(UserM user) async {
    await _userStore.doc(user.id).delete();
  }

  @override
  Stream<QuerySnapshot> watch(String name) async* {
    yield* _userStore
        // .where('name', isEqualTo: name)
        .orderBy('date', descending: true)
        .snapshots();
  }
}
