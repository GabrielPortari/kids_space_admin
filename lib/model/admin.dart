import 'package:kids_space_admin/model/base_user.dart';

class Admin extends BaseUser{
  List<String>? roles;
  bool? status;

  Admin({
    this.roles,
    this.status,
    super.userType,
    super.photoUrl,
    super.name,
    super.email,
    super.birthDate,
    super.document,
    super.phone,
    super.address,
    super.addressNumber,
    super.addressComplement,
    super.neighborhood,
    super.city,
    super.state,
    super.zipCode,
    super.companyId,
    super.id,
    super.createdAt,
    super.updatedAt
  }); 

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['roles'] = roles;
    base['status'] = status;
    return base;
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    final base = BaseUser.fromJson(map);

    final dynamic rolesRaw = map['roles'] ?? map['authorities'] ?? map['rolesList'];
    List<String>? roles;
    if (rolesRaw is List) {
      roles = rolesRaw.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }

    bool? status;
    if (map.containsKey('status')) {
      final v = map['status'];
      if (v is bool) status = v;
      else if (v != null) status = v.toString().toLowerCase() == 'true';
    }

    return Admin(
      roles: roles,
      status: status,
      userType: base.userType,
      photoUrl: base.photoUrl,
      name: base.name,
      email: base.email,
      birthDate: base.birthDate,
      document: base.document,
      phone: base.phone,
      address: base.address,
      addressNumber: base.addressNumber,
      addressComplement: base.addressComplement,
      neighborhood: base.neighborhood,
      city: base.city,
      state: base.state,
      zipCode: base.zipCode,
      companyId: base.companyId,
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
    );
  }
}