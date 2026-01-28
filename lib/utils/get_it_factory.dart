
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/admin_controller.dart';
import 'package:kids_space_admin/controller/attendance_controller.dart';
import 'package:kids_space_admin/controller/auth_controller.dart';
import 'package:kids_space_admin/controller/child_controller.dart';
import 'package:kids_space_admin/controller/collaborator_controller.dart';
import 'package:kids_space_admin/controller/company_controller.dart';
import 'package:kids_space_admin/controller/user_controller.dart';
import 'package:kids_space_admin/service/admin_service.dart';
import 'package:kids_space_admin/service/auth_service.dart';
import 'package:kids_space_admin/service/child_service.dart';
import 'package:kids_space_admin/service/collaborator_service.dart';
import 'package:kids_space_admin/service/company_service.dart';
import 'package:kids_space_admin/service/user_service.dart';

void setup(GetIt getIt) {
  getIt.registerSingleton<CompanyService>(CompanyService());
  getIt.registerSingleton<AdminService>(AdminService());
  getIt.registerSingleton<CollaboratorService>(CollaboratorService());
  getIt.registerSingleton<ChildService>(ChildService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<UserService>(UserService());

  getIt.registerSingleton<ChildController>(ChildController(getIt<ChildService>()));
  getIt.registerSingleton<UserController>(UserController(getIt<UserService>()));
  getIt.registerSingleton<AdminController>(AdminController());
  getIt.registerSingleton<AuthController>(AuthController());
  getIt.registerSingleton<AttendanceController>(AttendanceController());
  getIt.registerSingleton<CollaboratorController>(CollaboratorController());
  getIt.registerSingleton<CompanyController>(CompanyController());


}