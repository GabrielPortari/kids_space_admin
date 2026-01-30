import 'package:flutter/material.dart';
import 'package:kids_space_admin/model/collaborator.dart';

class CollaboratorDetails extends StatelessWidget {
  final Collaborator? collaborator;
  final String? collaboratorId;

  const CollaboratorDetails({Key? key, this.collaborator, this.collaboratorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (collaborator == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          collaboratorId == null || collaboratorId!.isEmpty
              ? 'Nenhum responsável associado'
              : 'Responsável não encontrado',
          textAlign: TextAlign.start,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: ${collaborator!.name ?? '—'}', textAlign: TextAlign.start),
          const SizedBox(height: 6),
          if (collaborator!.email != null) Text('Email: ${collaborator!.email!}', textAlign: TextAlign.start),
          if (collaborator!.phone != null) Text('Telefone: ${collaborator!.phone!}', textAlign: TextAlign.start),
          if (collaborator!.document != null) Text('Documento: ${collaborator!.document!}', textAlign: TextAlign.start),
          if (collaborator!.userType != null)
            Text('Tipo: ${collaborator!.userType.toString().split('.').last}', textAlign: TextAlign.start),
          if (collaborator!.roles != null) Text('Roles: ${collaborator!.roles!.join(', ')}', textAlign: TextAlign.start),
          if (collaborator!.companyId != null) Text('Company ID: ${collaborator!.companyId!}', textAlign: TextAlign.start),
          if (collaborator!.photoUrl != null) Text('Foto URL: ${collaborator!.photoUrl!}', textAlign: TextAlign.start),
          if (collaborator!.birthDate != null) Text('Data de nascimento: ${collaborator!.birthDate!}', textAlign: TextAlign.start),
          if (collaborator!.address != null)
            Text('Endereço: ${collaborator!.address ?? ''} ${collaborator!.addressNumber ?? ''} ${collaborator!.addressComplement ?? ''}', textAlign: TextAlign.start),
          if (collaborator!.city != null) Text('Cidade: ${collaborator!.city!}', textAlign: TextAlign.start),
          if (collaborator!.state != null) Text('Estado: ${collaborator!.state!}', textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
