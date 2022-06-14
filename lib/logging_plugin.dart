
import 'logging_plugin_platform_interface.dart';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GenericEventLogger {
  static int maxCacheLength = 50;
  static List<String> mapCache = [];
  static String _loggingURL = '';
  static Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  static AndroidDeviceInfo? _androidInfo;
  static IosDeviceInfo? _iosInfo;
  static WebBrowserInfo? _webBrowserInfo;
  static final Connectivity _connectivity = Connectivity();

  /// initialize the EventLogger
  static void init(String logURL) {
    _loggingURL = logURL;
  }

  ///private function to set the location internally
  static Future<void> _getLocation() async {
    bool isServiceEnabled = false;
    LocationPermission isPermissionEnabled = LocationPermission.denied;

    //first check if permissions are enabled
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled');
    }
    //then check if permisstions are enabled
    isPermissionEnabled = await Geolocator.checkPermission();
    if (isPermissionEnabled == LocationPermission.denied) {
      isPermissionEnabled = await Geolocator.requestPermission();
      if (isPermissionEnabled == LocationPermission.denied) {
        if (Platform.isAndroid) {
          //show an explanitory UI on android here per Android guidelines
        }
        return Future.error('Location permissions are denied');
      }
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }

  ///publicly accesible call to update location however often neccisary
  static void updateLocation() {
    _getLocation();
  }

  static Future<void> logEvent(String eventType, String eventDescription,
      {String? eventParam}) async {
    //structure location data
    Map locationData = {};
    locationData['longitude'] = _position.longitude;
    locationData['latitude'] = _position.latitude;
    locationData['timestamp'] = _position.timestamp;
    //structure time data
    DateTime timeStamp = DateTime.now().toUtc();
    Map timeData = {};
    timeData['timeIso8601'] = timeStamp.toIso8601String();
    timeData['timeMsEpoch'] = timeStamp.millisecondsSinceEpoch;
    timeData['timezone'] = timeStamp.timeZoneName;
    //structure device data
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map deviceData = {};
    if (Platform.isAndroid) {
      deviceData["platform"] = "Android";
      _androidInfo ??= await deviceInfo.androidInfo;
      deviceData['model'] = _androidInfo?.model;
      deviceData['osVersion'] = _androidInfo?.version.incremental;
      deviceData['manufacturer'] = _androidInfo?.manufacturer;
    }
    if (Platform.isIOS) {
      deviceData["platform"] = "IOS";
      _iosInfo ??= await deviceInfo.iosInfo;
      deviceData['model'] = _iosInfo?.model;
      deviceData['osVersion'] = _iosInfo?.systemVersion;
      deviceData['manufacturer'] = 'Apple';
    }
    if (kIsWeb) {
      deviceData["platform"] = "Web";
      _webBrowserInfo ??= await deviceInfo.webBrowserInfo;
      deviceData['userAgent'] = _webBrowserInfo?.userAgent;
      deviceData['osVersion'] = _webBrowserInfo?.platform;
      deviceData['manufacturer'] = _webBrowserInfo?.vendor;
    }

    Map eventData = {};
    //build telemetry packet
    eventData['locationData'] = locationData;
    eventData['deviceData'] = deviceData;
    eventData['timeData'] = timeData;
    eventData['eventType'] = eventType;
    eventData['eventDescription'] = eventDescription;
    if (eventParam != null) {
      eventData['eventParam'] = eventParam;
    }

    //check connection state
    ConnectivityResult connectivityResult =
    await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //connected send to data url
      http.Response response = await http.post(
        Uri.parse(_loggingURL),
        body: jsonEncode(eventData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //handle response here
    } else {
      //not connected to internet add to cache
      mapCache.add(jsonEncode(eventData));
      //if cache exeeds max size pop oldest
      if (mapCache.length > maxCacheLength) {
        mapCache.removeAt(0);
      }
    }
  }


}

class LoggingPlugin {
  Future<String?> getPlatformVersion() {
    return LoggingPluginPlatform.instance.getPlatformVersion();
  }
}











