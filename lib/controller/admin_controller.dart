import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/base_controller.dart';
import 'package:kids_space_admin/model/admin.dart';
import 'package:kids_space_admin/service/admin_service.dart';
import 'package:mobx/mobx.dart';

part 'admin_controller.g.dart';

class AdminController = _AdminController with _$AdminController;

abstract class _AdminController extends BaseController with Store {
  
  final AdminService _adminService = GetIt.I<AdminService>();

  @observable
  Admin? loggedAdmin;

  @action
  Future<void> setLoggedAdmin(Admin? admin)  async{
    loggedAdmin = admin;
    try {
      if (admin != null) {
        await secureStorage.write(key: 'loggedAdmin', value: jsonEncode(admin.toJson()));
      } else {
        await secureStorage.delete(key: 'loggedAdmin');
      }
    } catch (_) {}
  }

  @action
  Future<void> clearLoggedAdmin() async {
    loggedAdmin = null;
    try {
      await secureStorage.delete(key: 'loggedAdmin');
    } catch (_) {}
  }

  @action
  Future<bool> loadLoggedAdminFromPrefs() async {
    try {
      final jsonString = await secureStorage.read(key: 'loggedAdmin');
      if (jsonString != null && jsonString.isNotEmpty) {
        loggedAdmin = Admin.fromJson(jsonDecode(jsonString));
        return true;
      }
    } catch (_) {}
    loggedAdmin = null;
    return false;
  }

  Future<Admin?> getAdminById(String id) async {
    return await _adminService.getAdminById(id);
  }
}