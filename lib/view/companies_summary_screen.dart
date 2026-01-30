import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/company_controller.dart';
import 'package:kids_space_admin/model/company.dart';
import 'package:kids_space_admin/view/widgets/company_list.dart';
import 'package:kids_space_admin/service/collaborator_service.dart';
import 'package:kids_space_admin/model/collaborator.dart';
import 'package:kids_space_admin/view/widgets/collaborator_details.dart';
import 'package:kids_space_admin/view/widgets/company_details.dart';

class CompaniesSummaryScreen extends StatefulWidget {
  const CompaniesSummaryScreen({super.key});

  @override
  State<CompaniesSummaryScreen> createState() => _CompaniesSummaryScreenState();
}

class _CompaniesSummaryScreenState extends State<CompaniesSummaryScreen> {
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
        title: const Text('Consultar dados'),
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

        // prepare futures: fetch full company and responsible (if available)
        final Future<Company> companyFuture = (company.id != null && company.id!.isNotEmpty)
            ? _companyController.fetchCompanyById(company.id!).then((f) => f ?? company)
            : Future.value(company);

        final Future<Collaborator?> collaboratorFuture = (company.responsibleId != null && company.responsibleId!.isNotEmpty)
            ? GetIt.I<CollaboratorService>().getCollaboratorById(company.responsibleId!)
            : Future.value(null);

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(company.fantasyName ?? 'Empresa'),
              content: SizedBox(
                width: double.maxFinite,
                child: FutureBuilder<List<dynamic>>(
                  future: Future.wait([companyFuture, collaboratorFuture]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final fetchedCompany = snapshot.hasData ? snapshot.data![0] as Company : company;
                    final fetchedResponsible = snapshot.hasData ? snapshot.data![1] as Collaborator? : null;

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CompanyDetails(company: fetchedCompany),
                          const SizedBox(height: 12),
                          ExpansionTile(
                            title: const Text('Responsável'),
                            children: [
                              CollaboratorDetails(collaborator: fetchedResponsible, collaboratorId: company.responsibleId),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
        _companyController.resetSelectedCompany();
      },
    );
  }
}