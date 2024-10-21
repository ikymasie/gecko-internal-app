import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // Function to check and request multiple permissions
  Future<Map<Permission, PermissionStatus>> checkAndRequestPermissions(
      List<Permission> permissions) async {
    // A map to store the permission statuses
    Map<Permission, PermissionStatus> permissionStatuses = {};

    // Check each permission in the list
    for (var permission in permissions) {
      // If the permission is not granted, request it
      if (await permission.isGranted) {
        permissionStatuses[permission] = PermissionStatus.granted;
      } else {
        final status = await permission.request();
        permissionStatuses[permission] = status;
      }
    }

    // Return the statuses of the requested permissions
    return permissionStatuses;
  }
}
