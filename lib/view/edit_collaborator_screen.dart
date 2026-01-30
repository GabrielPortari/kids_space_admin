import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/service/collaborator_service.dart';
import 'package:kids_space_admin/model/collaborator.dart';

class EditCollaboratorScreen extends StatefulWidget {
  final String collaboratorId;
  const EditCollaboratorScreen({Key? key, required this.collaboratorId}) : super(key: key);

  @override
  State<EditCollaboratorScreen> createState() => _EditCollaboratorScreenState();
}

class _EditCollaboratorScreenState extends State<EditCollaboratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final CollaboratorService _service = GetIt.I<CollaboratorService>();

  bool _loading = true;
  bool _saving = false;
  Collaborator? _collab;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _documentController;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await _service.getCollaboratorById(widget.collaboratorId);
    _collab = c;
    _nameController = TextEditingController(text: _collab?.name);
    _emailController = TextEditingController(text: _collab?.email);
    _phoneController = TextEditingController(text: _collab?.phone);
    _documentController = TextEditingController(text: _collab?.document);
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final updated = Collaborator(
      id: _collab?.id,
      createdAt: _collab?.createdAt,
      updatedAt: DateTime.now(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      document: _documentController.text.trim(),
      companyId: _collab?.companyId,
      photoUrl: _collab?.photoUrl,
      roles: _collab?.roles,
      isActive: _collab?.isActive,
    );

    final ok = await _service.updateCollaborator(updated);
    setState(() => _saving = false);
    if (ok) {
      if (mounted) Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar responsável')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Responsável')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
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
                controller: _documentController,
                decoration: const InputDecoration(labelText: 'Documento'),
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
