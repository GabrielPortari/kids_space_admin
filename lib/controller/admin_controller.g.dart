// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminController on _AdminController, Store {
  late final _$loggedAdminAtom = Atom(
    name: '_AdminController.loggedAdmin',
    context: context,
  );

  @override
  Admin? get loggedAdmin {
    _$loggedAdminAtom.reportRead();
    return super.loggedAdmin;
  }

  @override
  set loggedAdmin(Admin? value) {
    _$loggedAdminAtom.reportWrite(value, super.loggedAdmin, () {
      super.loggedAdmin = value;
    });
  }

  late final _$setLoggedAdminAsyncAction = AsyncAction(
    '_AdminController.setLoggedAdmin',
    context: context,
  );

  @override
  Future<void> setLoggedAdmin(Admin? admin) {
    return _$setLoggedAdminAsyncAction.run(() => super.setLoggedAdmin(admin));
  }

  late final _$clearLoggedAdminAsyncAction = AsyncAction(
    '_AdminController.clearLoggedAdmin',
    context: context,
  );

  @override
  Future<void> clearLoggedAdmin() {
    return _$clearLoggedAdminAsyncAction.run(() => super.clearLoggedAdmin());
  }

  late final _$loadLoggedAdminFromPrefsAsyncAction = AsyncAction(
    '_AdminController.loadLoggedAdminFromPrefs',
    context: context,
  );

  @override
  Future<bool> loadLoggedAdminFromPrefs() {
    return _$loadLoggedAdminFromPrefsAsyncAction.run(
      () => super.loadLoggedAdminFromPrefs(),
    );
  }

  @override
  String toString() {
    return '''
loggedAdmin: ${loggedAdmin}
    ''';
  }
}
