import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/status_controller.dart';

import 'package:final_projectt/models/status_model.dart';

import 'package:flutter/material.dart';

class StatuseProvider extends ChangeNotifier {
  late StatusController _statusController;
  late ApiResponse<StatusesesModel> _dataStatuse;

  StatuseProvider() {
    _statusController = StatusController();
    getStatuseData();
  }

  ApiResponse<StatusesesModel> get statusedata => _dataStatuse;

  Future<void> getStatuseData() async {
    _dataStatuse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _statusController.fetchStatuse();
      _dataStatuse = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _dataStatuse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
