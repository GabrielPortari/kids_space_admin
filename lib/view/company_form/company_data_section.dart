import 'package:flutter/material.dart';

class CompanyDataSection extends StatelessWidget {
  final TextEditingController fantasyName;
  final TextEditingController corporateName;
  final TextEditingController cnpj;
  final TextEditingController website;
  final TextEditingController email;
  final TextEditingController phone;

  const CompanyDataSection({
    super.key,
    required this.fantasyName,
    required this.corporateName,
    required this.cnpj,
    required this.website,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Dados da empresa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: fantasyName, decoration: const InputDecoration(labelText: 'Nome fantasia')),
              const SizedBox(height: 8),
              TextFormField(controller: corporateName, decoration: const InputDecoration(labelText: 'Razão social')),
              const SizedBox(height: 8),
              TextFormField(controller: cnpj, decoration: const InputDecoration(labelText: 'CNPJ')),
              const SizedBox(height: 8),
              TextFormField(controller: website, decoration: const InputDecoration(labelText: 'Website')),
              const SizedBox(height: 8),
              TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextFormField(controller: phone, decoration: const InputDecoration(labelText: 'Telefone')),
            ],
          ),
        ],
      ),
    );
  }
}
