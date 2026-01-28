import 'package:flutter/material.dart';
import 'package:kids_space_admin/view/company_form/company_form.dart';
import 'package:kids_space_admin/model/company.dart';

class RegisterCompanyScreen extends StatelessWidget {
  const RegisterCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar empresa')),
      body: CompanyForm(
        onSaved: (Company c) {
          Navigator.of(context).pop(c);
        },
      ),
    );
  }
}
