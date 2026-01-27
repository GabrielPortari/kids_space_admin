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
}