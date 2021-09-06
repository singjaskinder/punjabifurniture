import 'package:punjabifurniture/models/user_m.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences saver;
  static Future<void> init() async {
    saver = await SharedPreferences.getInstance();
  }

  static void saveUserDetails(UserM user) {
    saver.setString('id', user.id ?? '');
    saver.setString('company', user.company ?? '');
    saver.setString('email', user.email ?? '');
    saver.setString('phone', user.phone ?? '');
    // saver.setString('password', user.password ?? '');
    saver.setString('address', user.address ?? '');
    saver.setString('name', user.name ?? '');
    saver.setString('type', user.type ?? '');
    saver.setString('status', user.status ?? '');
  }

  static void clearAll() {
    saver.clear();
  }
}
