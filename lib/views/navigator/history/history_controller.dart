import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:punjabifurniture/apis/order.dart';
import 'package:punjabifurniture/utils/functions/preferences.dart';

class HistoryController extends GetxController {
  final orderApis = OrderRepo();
  late bool isAdmin;
  @override
  void onInit() {
    isAdmin = (Preferences.saver.getString('type') ?? 'admin') == 'admin';
    super.onInit();
  }

  Stream<QuerySnapshot> watch() async* {
    if (isAdmin) {
      yield* watchForAdmin();
    } else {
      yield* watchForUser();
    }
  }

  Stream<QuerySnapshot> watchForAdmin() async* {
    yield* orderApis.watch(true, '', isAdmin);
  }

  Stream<QuerySnapshot> watchForUser() async* {
    String id = Preferences.saver.getString('id')!;
    yield* orderApis.watch(true, id, isAdmin);
  }
}
