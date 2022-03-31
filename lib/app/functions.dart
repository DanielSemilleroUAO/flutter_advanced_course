import 'dart:io';

import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

Future<DeviceInfo> getDeviceDetails() async {
  String name = "Uknown";
  String identifier = "Uknown";
  String version = "Uknown";

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      name = build.brand! + " " + build.model!;
      identifier = build.androidId!;
      version = build.version.codename!;
    } else if (Platform.isIOS) {
      var build = await deviceInfoPlugin.iosInfo;
      name = build.name! + " " + build.model!;
      identifier = build.identifierForVendor!;
      version = build.systemVersion!;
    }
  } on PlatformException {
    return DeviceInfo(name, identifier, version);
  }
  return DeviceInfo(name, identifier, version);
}

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
