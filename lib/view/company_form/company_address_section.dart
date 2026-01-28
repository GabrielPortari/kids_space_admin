import 'package:flutter/material.dart';

class CompanyAddressSection extends StatelessWidget {
  final TextEditingController address;
  final TextEditingController addressNumber;
  final TextEditingController addressComplement;
  final TextEditingController neighborhood;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController zipCode;

  const CompanyAddressSection({
    super.key,
    required this.address,
    required this.addressNumber,
    required this.addressComplement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Endereço da empresa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        initiallyExpanded: false,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: address, decoration: const InputDecoration(labelText: 'Endereço')),
              const SizedBox(height: 8),
              TextFormField(controller: addressNumber, decoration: const InputDecoration(labelText: 'Número')),
              const SizedBox(height: 8),
              TextFormField(controller: addressComplement, decoration: const InputDecoration(labelText: 'Complemento')),
              const SizedBox(height: 8),
              TextFormField(controller: neighborhood, decoration: const InputDecoration(labelText: 'Bairro')),
              const SizedBox(height: 8),
              TextFormField(controller: city, decoration: const InputDecoration(labelText: 'Cidade')),
              const SizedBox(height: 8),
              TextFormField(controller: state, decoration: const InputDecoration(labelText: 'Estado')),
              const SizedBox(height: 8),
              TextFormField(controller: zipCode, decoration: const InputDecoration(labelText: 'CEP')),
            ],
          ),
        ],
      ),
    );
  }
}
