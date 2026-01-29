import 'package:flutter/material.dart';
import 'package:kids_space_admin/model/collaborator.dart';
import 'package:kids_space_admin/model/company.dart';
import 'company_data_section.dart';
import 'company_address_section.dart';
import 'responsible_data_section.dart';
import 'responsible_address_section.dart';

class CompanyForm extends StatefulWidget {
  final void Function(Company, Collaborator?) onSaved;
  const CompanyForm({super.key, required this.onSaved});

  @override
  State<CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();

  // Company data
  final _fantasyName = TextEditingController();
  final _corporateName = TextEditingController();
  final _cnpj = TextEditingController();
  final _website = TextEditingController();
  final _companyEmail = TextEditingController();
  final _companyPhone = TextEditingController();

  // Company address
  final _address = TextEditingController();
  final _addressNumber = TextEditingController();
  final _addressComplement = TextEditingController();
  final _neighborhood = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zipCode = TextEditingController();

  // Responsible data
  final _respName = TextEditingController();
  final _respEmail = TextEditingController();
  final _respPhone = TextEditingController();

  // Responsible address
  final _respAddress = TextEditingController();
  final _respAddressNumber = TextEditingController();
  final _respAddressComplement = TextEditingController();
  final _respNeighborhood = TextEditingController();
  final _respCity = TextEditingController();
  final _respState = TextEditingController();
  final _respZipCode = TextEditingController();

  @override
  void dispose() {
    _fantasyName.dispose();
    _corporateName.dispose();
    _cnpj.dispose();
    _website.dispose();
    _companyEmail.dispose();
    _companyPhone.dispose();

    _address.dispose();
    _addressNumber.dispose();
    _addressComplement.dispose();
    _neighborhood.dispose();
    _city.dispose();
    _state.dispose();
    _zipCode.dispose();

    _respName.dispose();
    _respEmail.dispose();
    _respPhone.dispose();
    _respAddress.dispose();
    _respAddressNumber.dispose();
    _respAddressComplement.dispose();
    _respNeighborhood.dispose();
    _respCity.dispose();
    _respState.dispose();
    _respZipCode.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final responsible = Collaborator(
      name: _respName.text.trim().isEmpty ? null : _respName.text.trim(),
      email: _respEmail.text.trim().isEmpty ? null : _respEmail.text.trim(),
      phone: _respPhone.text.trim().isEmpty ? null : _respPhone.text.trim(),
      address: _respAddress.text.trim().isEmpty ? null : _respAddress.text.trim(),
      addressNumber: _respAddressNumber.text.trim().isEmpty ? null : _respAddressNumber.text.trim(),
      addressComplement: _respAddressComplement.text.trim().isEmpty ? null : _respAddressComplement.text.trim(),
      neighborhood: _respNeighborhood.text.trim().isEmpty ? null : _respNeighborhood.text.trim(),
      city: _respCity.text.trim().isEmpty ? null : _respCity.text.trim(),
      state: _respState.text.trim().isEmpty ? null : _respState.text.trim(),
      zipCode: _respZipCode.text.trim().isEmpty ? null : _respZipCode.text.trim(),
      id: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final company = Company(
      id: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      fantasyName: _fantasyName.text.trim().isEmpty ? null : _fantasyName.text.trim(),
      corporateName: _corporateName.text.trim().isEmpty ? null : _corporateName.text.trim(),
      cnpj: _cnpj.text.trim().isEmpty ? null : _cnpj.text.trim(),
      website: _website.text.trim().isEmpty ? null : _website.text.trim(),
      email: _companyEmail.text.trim().isEmpty ? null : _companyEmail.text.trim(),
      phone: _companyPhone.text.trim().isEmpty ? null : _companyPhone.text.trim(),
      address: _address.text.trim().isEmpty ? null : _address.text.trim(),
      addressNumber: _addressNumber.text.trim().isEmpty ? null : _addressNumber.text.trim(),
      addressComplement: _addressComplement.text.trim().isEmpty ? null : _addressComplement.text.trim(),
      neighborhood: _neighborhood.text.trim().isEmpty ? null : _neighborhood.text.trim(),
      city: _city.text.trim().isEmpty ? null : _city.text.trim(),
      state: _state.text.trim().isEmpty ? null : _state.text.trim(),
      zipCode: _zipCode.text.trim().isEmpty ? null : _zipCode.text.trim(),
      responsibleId: null,
      logoUrl: null,
    );

    widget.onSaved(company, responsible);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          CompanyDataSection(
            fantasyName: _fantasyName,
            corporateName: _corporateName,
            cnpj: _cnpj,
            website: _website,
            email: _companyEmail,
            phone: _companyPhone,
          ),
          const SizedBox(height: 12),
          CompanyAddressSection(
            address: _address,
            addressNumber: _addressNumber,
            addressComplement: _addressComplement,
            neighborhood: _neighborhood,
            city: _city,
            state: _state,
            zipCode: _zipCode,
          ),
          const SizedBox(height: 12),
          ResponsibleDataSection(
            name: _respName,
            email: _respEmail,
            phone: _respPhone,
          ),
          const SizedBox(height: 12),
          ResponsibleAddressSection(
            address: _respAddress,
            addressNumber: _respAddressNumber,
            addressComplement: _respAddressComplement,
            neighborhood: _respNeighborhood,
            city: _respCity,
            state: _respState,
            zipCode: _respZipCode,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _submit, child: const Text('Salvar')),
        ],
      ),
    );
  }
}
