import 'package:flutter/material.dart';

class ResponsibleDataSection extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;

  const ResponsibleDataSection({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Dados do responsável', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 8),
            TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextFormField(controller: phone, decoration: const InputDecoration(labelText: 'Telefone')),
          ],
        ),
      ),
    );
  }
}
