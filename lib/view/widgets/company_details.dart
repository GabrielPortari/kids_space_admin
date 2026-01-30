import 'package:flutter/material.dart';
import 'package:kids_space_admin/model/company.dart';

class CompanyDetails extends StatelessWidget {
  final Company company;

  const CompanyDetails({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (company.fantasyName != null) Text('Nome fantasia: ${company.fantasyName}', textAlign: TextAlign.start),
          if (company.corporateName != null) Text('Razão social: ${company.corporateName}', textAlign: TextAlign.start),
          if (company.cnpj != null) Text('CNPJ: ${company.cnpj}', textAlign: TextAlign.start),
          if (company.email != null) Text('Email: ${company.email}', textAlign: TextAlign.start),
          if (company.phone != null) Text('Telefone: ${company.phone}', textAlign: TextAlign.start),
          if (company.website != null) Text('Site: ${company.website}', textAlign: TextAlign.start),
          if (company.address != null)
            Text('Endereço: ${company.address ?? ''} ${company.addressNumber ?? ''} ${company.addressComplement ?? ''}', textAlign: TextAlign.start),
          if (company.neighborhood != null) Text('Bairro: ${company.neighborhood}', textAlign: TextAlign.start),
          if (company.city != null) Text('Cidade: ${company.city}', textAlign: TextAlign.start),
          if (company.state != null) Text('Estado: ${company.state}', textAlign: TextAlign.start),
          if (company.zipCode != null) Text('CEP: ${company.zipCode}', textAlign: TextAlign.start),
          if (company.responsibleId != null) Text('Responsible ID: ${company.responsibleId}', textAlign: TextAlign.start),
          if (company.logoUrl != null) Text('Logo URL: ${company.logoUrl}', textAlign: TextAlign.start),
          if (company.collaborators != null) Text('Colaboradores: ${company.collaborators}', textAlign: TextAlign.start),
          if (company.users != null) Text('Usuários: ${company.users}', textAlign: TextAlign.start),
          if (company.children != null) Text('Crianças: ${company.children}', textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
