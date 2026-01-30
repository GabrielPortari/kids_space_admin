import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/company_controller.dart';
import 'package:kids_space_admin/model/company.dart';

class EditCompanyScreen extends StatefulWidget {
  final Company company;
  const EditCompanyScreen({Key? key, required this.company}) : super(key: key);

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fantasyNameController;
  late TextEditingController _corporateNameController;
  late TextEditingController _cnpjController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  late TextEditingController _addressNumberController;
  late TextEditingController _addressComplementController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  final CompanyController _companyController = GetIt.I<CompanyController>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    _fantasyNameController = TextEditingController(text: c.fantasyName);
    _corporateNameController = TextEditingController(text: c.corporateName);
    _cnpjController = TextEditingController(text: c.cnpj);
    _emailController = TextEditingController(text: c.email);
    _phoneController = TextEditingController(text: c.phone);
    _websiteController = TextEditingController(text: c.website);
    _addressController = TextEditingController(text: c.address);
    _addressNumberController = TextEditingController(text: c.addressNumber);
    _addressComplementController = TextEditingController(text: c.addressComplement);
    _neighborhoodController = TextEditingController(text: c.neighborhood);
    _cityController = TextEditingController(text: c.city);
    _stateController = TextEditingController(text: c.state);
    _zipController = TextEditingController(text: c.zipCode);
  }

  @override
  void dispose() {
    _fantasyNameController.dispose();
    _corporateNameController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _addressNumberController.dispose();
    _addressComplementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final updated = Company(
      id: widget.company.id,
      createdAt: widget.company.createdAt,
      updatedAt: DateTime.now(),
      fantasyName: _fantasyNameController.text.trim(),
      corporateName: _corporateNameController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      website: _websiteController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      addressNumber: _addressNumberController.text.trim(),
      addressComplement: _addressComplementController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipController.text.trim(),
      responsibleId: widget.company.responsibleId,
      logoUrl: widget.company.logoUrl,
      collaborators: widget.company.collaborators,
      users: widget.company.users,
      children: widget.company.children,
    );

    final ok = await _companyController.updateCompany(updated);
    setState(() => _saving = false);
    if (ok) {
      if (mounted) Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar empresa')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fantasyNameController,
                decoration: const InputDecoration(labelText: 'Nome fantasia'),
              ),
              TextFormField(
                controller: _corporateNameController,
                decoration: const InputDecoration(labelText: 'Razão social'),
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Site'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              TextFormField(
                controller: _addressNumberController,
                decoration: const InputDecoration(labelText: 'Número'),
              ),
              TextFormField(
                controller: _addressComplementController,
                decoration: const InputDecoration(labelText: 'Complemento'),
              ),
              TextFormField(
                controller: _neighborhoodController,
                decoration: const InputDecoration(labelText: 'Bairro'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const CircularProgressIndicator() : const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
