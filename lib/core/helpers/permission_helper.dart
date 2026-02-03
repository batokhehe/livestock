import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<bool> camera() async {
    var status = await Permission.camera.status;

    if (status.isDenied || status.isLimited) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }
}
