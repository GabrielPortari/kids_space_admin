import 'package:flutter/material.dart';

class ManageCompanyScreen extends StatelessWidget {
  const ManageCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar empresas')),
      body: Center(child: Text('Tela de gerenciamento de empresas'))
    );
  }
}
