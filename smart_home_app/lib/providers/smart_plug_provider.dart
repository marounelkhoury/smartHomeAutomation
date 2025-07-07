import 'package:flutter/material.dart';
import '../models/smart_plug.dart';
import '../core/api_service.dart';
import '../core/notification_service.dart';

class SmartPlugProvider extends ChangeNotifier {
  List<SmartPlug> _plugs = [];

  List<SmartPlug> get plugs => _plugs;


  Future<void> fetchPlugs() async {
    print("Fetching smart plugs..."); // Debugging line
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulating network delay
      _plugs = [
        SmartPlug(id: 1, name: "Living Room Plug", status: false),
        SmartPlug(id: 2, name: "Bedroom Plug", status: false),
        SmartPlug(id: 3, name: "Kitchen Plug", status: false),
      ];
      print("Smart plugs loaded successfully"); // Debugging line
      notifyListeners();
    } catch (e) {
      print("Error fetching smart plugs: $e"); // Debugging line
    }
  }


  void togglePlug(int id, bool status) {
    final index = _plugs.indexWhere((plug) => plug.id == id);
    if (index != -1) {
      _plugs[index].status = status;
      notifyListeners();

      //send a notification:
      String statusText = status ? "ON" : "OFF";
      NotificationService.showNotification(
        "Smart Plug Updated",
        "${_plugs[index].name} is now $statusText",
      );
    }
  }
}