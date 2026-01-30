import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/company_controller.dart';
import 'package:kids_space_admin/model/company.dart';
import 'package:kids_space_admin/view/widgets/company_list.dart';

class ManageCompanyScreen extends StatefulWidget {
  const ManageCompanyScreen({super.key});

  @override
  State<ManageCompanyScreen> createState() => _ManageCompanyScreenState();
}

class _ManageCompanyScreenState extends State<ManageCompanyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CompanyController _companyController = GetIt.I<CompanyController>();
  List<Company> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredCompanies();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(_updateFilteredCompanies);
  }

  void _updateFilteredCompanies() {
    _filteredCompanies = _companyController.filterCompanies(
      _searchController.text,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Empresas'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _searchField(),
                    const SizedBox(height: 16),
                    Expanded(child: _buildCompaniesArea()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Buscar empresa',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filteredCompanies = [];
                },
              ),
      ),
    );
  }

  Widget _buildCompaniesArea() {
    if (_searchController.text.isEmpty) {
      return const Center(
        child: Text(
          'Digite para buscar uma empresa',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    if (_filteredCompanies.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma empresa encontrada',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return CompanyList(
      companies: _filteredCompanies,
      onTap: (company) async {
        _companyController.selectCompany(company);

        final choice = await showDialog<String>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('O que deseja editar?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Alterar dados da empresa'),
                    onTap: () => Navigator.of(context).pop('company'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Alterar dados do responsável'),
                    onTap: () => Navigator.of(context).pop('responsible'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );

        // navigate to edit screens based on choice
        if (choice == 'company') {
          await Navigator.of(context).pushNamed('/edit-company', arguments: company);
          // optionally handle result
        } else if (choice == 'responsible') {
          final responsibleId = company.responsibleId;
          if (responsibleId != null && responsibleId.isNotEmpty) {
            await Navigator.of(context).pushNamed('/edit-responsible', arguments: responsibleId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empresa não possui responsável')));
          }
        }

        _companyController.resetSelectedCompany();
      },
    );
  }
}
