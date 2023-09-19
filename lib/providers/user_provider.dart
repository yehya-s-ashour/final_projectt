import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/user_controller.dart';
import 'package:final_projectt/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late UserController _userController;
  late ApiResponse<UserModel> _data;

  UserProvider() {
    _userController = UserController();
    getUserData();
  }
  ApiResponse<UserModel> get data => _data;
  void updatuser() {
    getUserData();
  }

  Future<void> getUserData() async {
    _data = ApiResponse.loading('Loading');

    notifyListeners();
    try {
      final response = await _userController.getLocalUser();

      _data = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      _data = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
