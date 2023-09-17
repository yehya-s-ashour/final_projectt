import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/user_role_controller.dart';
import 'package:final_projectt/models/user_role_model.dart';
import 'package:flutter/material.dart';

class UserRoleProvider extends ChangeNotifier {
  late UserRoleController _userRoleController;
  late ApiResponse<UserRole> _dataUserRole;

  UserRoleProvider() {
    _userRoleController = UserRoleController();
    getUserRoleData();
  }
  void updateUserRole() {
    getUserRoleData();
  }

  ApiResponse<UserRole> get userRoledata => _dataUserRole;
  Future<void> getUserRoleData() async {
    _dataUserRole = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _userRoleController.fetchUserRoleData();
      _dataUserRole = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _dataUserRole = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
