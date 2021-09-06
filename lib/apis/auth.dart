import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:punjabifurniture/models/user_m.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';

abstract class AuthApis {
  Future<void> register(UserM user);
  Future<void> login(UserM user);
  Future<void> sendPasswordLink(String email);
  Future<UserM> getDetails(UserM userM);
  Future<void> logout();
}

class AuthRepo extends AuthApis {
  final _userStore = FirebaseFirestore.instance.collection('users');
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> register(UserM user) async {
    final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!, password: user.id!);
    user.id = userCred.user!.uid;
    await _userStore.doc(user.id).set(user.toJson());
  }

  @override
  Future<void> login(UserM user) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email!, password: user.id!);
  }

  @override
  Future<void> sendPasswordLink(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserM> getDetails(UserM user) async {
    final data =
        await _userStore.where('email', isEqualTo: user.email).limit(1).get();
    if (data.docs.isNotEmpty) {
      return UserM.fromJson(data.docs[0].data());
    } else {
      return UserM();
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await Preferences.saver.clear();
  }
}
