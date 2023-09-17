import 'package:final_projectt/core/helpers/api_response.dart';
import 'package:final_projectt/core/services/all_user_controller.dart';
import 'package:final_projectt/models/all_user_model.dart';
import 'package:flutter/material.dart';

class AllUserProvider extends ChangeNotifier {
  late AllUserController _allUserController;
  late ApiResponse<AllUserModel> _dataUser;

  AllUserProvider() {
    _allUserController = AllUserController();
    getusersData();
  }
  void UpdateAllUserProvider() {
    getusersData();
  }

  ApiResponse<AllUserModel> get allUserdata => _dataUser;
  Future<void> getusersData() async {
    _dataUser = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      final response = await _allUserController.fetchUsersData();
      _dataUser = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _dataUser = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
