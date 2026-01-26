import 'package:flutter/material.dart';

class CompaniesSummaryScreen extends StatelessWidget {
  const CompaniesSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empresas cadastradas')),
      body: Center(child: Text('Tela de empresas cadastradas'))
    );
  }
}
