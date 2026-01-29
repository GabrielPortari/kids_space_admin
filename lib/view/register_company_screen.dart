import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/company_controller.dart';
import 'package:kids_space_admin/model/collaborator.dart';
import 'package:kids_space_admin/view/company_form/company_form.dart';
import 'package:kids_space_admin/model/company.dart';
import 'package:kids_space_admin/model/base_user.dart';
 

class RegisterCompanyScreen extends StatelessWidget {
  const RegisterCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyController _companyController = GetIt.I<CompanyController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar empresa')),
      body: CompanyForm(
        onSaved: (Company c, Collaborator? responsible) async {
          final ok = await _companyController.registerCompanyWithResponsible(c, responsible);
          if (ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Empresa cadastrada com sucesso!')),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao cadastrar empresa.')),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Gerar empresa'),
        onPressed: () async {
            final responsible = Collaborator(
              userType: UserType.companyAdmin,
              photoUrl: null,
              roles: ['companyAdmin'],
              name: 'Responsável Demo',
              email: 'responsavel@demo.empresa',
              birthDate: '1990-01-01',
              document: '123.456.789-00',
              phone: '11999990001',
              address: 'Rua Exemplo',
              addressNumber: '123',
              addressComplement: 'Sala 1',
              neighborhood: 'Centro',
              city: 'Cidade Exemplo',
              state: 'EX',
              zipCode: '00000-000',
              companyId: null,
              id: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
          );
          final sample = Company(
            id: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            fantasyName: 'Empresa Demo',
            corporateName: 'Empresa Demo LTDA',
            cnpj: '00.000.000/0001-00',
            website: 'https://demo.empresa',
            email: 'contato@demo.empresa',
            phone: '11999990000',
            address: 'Rua Exemplo',
            addressNumber: '123',
            addressComplement: 'Sala 1',
            neighborhood: 'Centro',
            city: 'Cidade Exemplo',
            state: 'EX',
            zipCode: '00000-000',
            logoUrl: null,
            responsibleId: null,
            collaborators: 5,
            users: 10,
            children: 20,
          );

          final ok = await _companyController.registerCompanyWithResponsible(sample, responsible);
          if (ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Empresa de exemplo cadastrada com sucesso!')),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao cadastrar empresa de exemplo.')),
            );
          }
        },
      ),
    );
  }
}
