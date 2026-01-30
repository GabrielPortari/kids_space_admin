import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'dart:developer' as dev;
import '../model/company.dart';
import '../model/collaborator.dart';
import '../service/collaborator_service.dart';
import '../service/company_service.dart';
import '../utils/network_exceptions.dart';
import 'base_controller.dart';

part 'company_controller.g.dart';
class CompanyController = _CompanyControllerBase with _$CompanyController;
abstract class _CompanyControllerBase extends BaseController with Store {
  final CompanyService _companyService = GetIt.I<CompanyService>();
  final CollaboratorService _collaboratorService = GetIt.I<CollaboratorService>();

  List<Company> _companies = [];

  String? error;

  Company? _companySelected;

  List<Company> get companies => _companies;

  Company? get companySelected => _companySelected;

  @observable
  bool isLoading = false;
  Future<void> loadCompanies({
    void Function(bool isLoading)? onLoading,
    void Function(List<Company> companies)? onSuccess,
    void Function(String message)? onError,
  }) async {
    try {
      isLoading = true;
      onLoading?.call(true);
      final result = await _companyService.getAllCompanies();
      _companies = result;
      onSuccess?.call(_companies);
    } catch (e) {
      if (e is NetworkException) {
        error = e.message;
      } else {
        error = e.toString();
      }
      onError?.call(error ?? '');
    } finally {
      isLoading = false;
      onLoading?.call(false);
    }
  }

  List<Company> filterCompanies(String query) {
    if (query.isEmpty) return _companies;
    return _companies
        .where((company) => company.fantasyName?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  void selectCompany(Company company) {
    _companySelected = company;
  }

  /// Reseta a empresa selecionada para null.
  void resetSelectedCompany() {
    _companySelected = null;
  }

  Future<bool> registerCompany(Company company) async {
    try {
      isLoading = true;
      final result = await _companyService.registerCompany(company);
      if(result) _companies.add(company);
      return true;
    } catch (e) {
      if (e is NetworkException) {
        error = e.message;
      } else {
        error = e.toString();
      }
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateCompany(Company company) async {
    try {
      isLoading = true;
      final result = await _companyService.updateCompany(company);
      if (result && company.id != null) {
        final idx = _companies.indexWhere((c) => c.id == company.id);
        if (idx >= 0) {
          _companies[idx] = company;
        } else {
          _companies.add(company);
        }
      }
      return result;
    } catch (e) {
      if (e is NetworkException) {
        error = e.message;
      } else {
        error = e.toString();
      }
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// Create company first, then create collaborator (responsible) with companyId
  /// and update company.responsibleId. Returns true on full success.
  Future<bool> registerCompanyWithResponsible(Company company, Collaborator? responsible) async {
    try {
      isLoading = true;

      final createdCompanyId = await _companyService.createCompanyReturnId(company);
      dev.log('Created company id: $createdCompanyId', name: 'CompanyController');
      if (createdCompanyId == null) return false;

      String? responsibleId = company.responsibleId;
      if (responsible != null) {
        final collab = Collaborator(
          userType: responsible.userType,
          photoUrl: responsible.photoUrl,
          roles: responsible.roles,
          name: responsible.name,
          email: responsible.email,
          birthDate: responsible.birthDate,
          document: responsible.document,
          phone: responsible.phone,
          address: responsible.address,
          addressNumber: responsible.addressNumber,
          addressComplement: responsible.addressComplement,
          neighborhood: responsible.neighborhood,
          city: responsible.city,
          state: responsible.state,
          zipCode: responsible.zipCode,
          companyId: createdCompanyId,
          id: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final createdId = await _collaboratorService.createCollaboratorReturnId(collab);
        if (createdId == null) {
          // collaborator creation failed; rollback company to avoid orphan
          dev.log('Collaborator creation failed, rolling back company id=$createdCompanyId', name: 'CompanyController');
          await _companyService.deleteCompany(createdCompanyId);
          return false;
        }
        responsibleId = createdId;

        // update company responsibleId
        await _companyService.updateCompanyResponsible(createdCompanyId, createdId);
      }

      // fetch and cache created company
      final fetched = await fetchCompanyById(createdCompanyId);
      if (fetched == null) {
        // still consider success since company was created
        _companies.add(Company(id: createdCompanyId, createdAt: company.createdAt, updatedAt: company.updatedAt, fantasyName: company.fantasyName, corporateName: company.corporateName, cnpj: company.cnpj, website: company.website, email: company.email, phone: company.phone, address: company.address, addressNumber: company.addressNumber, addressComplement: company.addressComplement, neighborhood: company.neighborhood, city: company.city, state: company.state, zipCode: company.zipCode, responsibleId: responsibleId, logoUrl: company.logoUrl, collaborators: company.collaborators, users: company.users, children: company.children));
      }

      return true;
    } catch (e) {
      if (e is NetworkException) {
        error = e.message;
      } else {
        error = e.toString();
      }
      return false;
    } finally {
      isLoading = false;
    }
  }
  
  /// Synchronous lookup from cached list. Returns null if not found or id empty.
  Company? getCompanyById(String id) {
    if (id.isEmpty) return null;
    for (final c in _companies) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Fetch company from API and update cache. Returns the fetched company or null on error.
  Future<Company?> fetchCompanyById(String id) async {
    if (id.isEmpty) return null;
    try {
      final result = await _companyService.getCompanyById(id);
      // update or add to cache
      final idx = _companies.indexWhere((c) => c.id == result.id);
      if (idx >= 0) {
        _companies[idx] = result;
      } else {
        _companies.add(result);
      }
      return result;
    } catch (e) {
      if (e is NetworkException) {
        error = e.message;
      } else {
        error = e.toString();
      }
      return null;
    }
  }
}