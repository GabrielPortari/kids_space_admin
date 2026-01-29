import 'dart:developer' as dev;
import 'package:dio/dio.dart';

import '../model/company.dart';
import 'base_service.dart';

class CompanyService extends BaseService {
  
  Future<List<Company>> getAllCompanies() async {
    try{
      final response = await dio.get('/companies');
      dev.log('getAllCompanies response status: ${response.statusCode}', name: 'CompanyService');
      final companiesData = response.data as List<dynamic>;
      final list = companiesData.map((data) => Company.fromJson(data)).toList();
      dev.log('getAllCompanies parsed ${list.length} companies', name: 'CompanyService');
      return list;
    } catch (e, st) {
      dev.log('getAllCompanies failed', name: 'CompanyService', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Company> getCompanyById(String id) async {
    try{
      final response = await dio.get('/companies/$id');
      dev.log('getCompanyById response status: ${response.statusCode}', name: 'CompanyService');
      if (response.statusCode == 200 && response.data != null) {
        dynamic payload = response.data;
        if (payload is Map<String, dynamic>) {
          if (payload['data'] is Map<String, dynamic>) payload = payload['data'];
          else if (payload['company'] is Map<String, dynamic>) payload = payload['company'];
          else if (payload['result'] is Map<String, dynamic>) payload = payload['result'];
        }

        if (payload is Map<String, dynamic>) {
          if (payload['id'] == null || (payload['id'] is String && (payload['id'] as String).isEmpty)) {
            payload['id'] = id;
            dev.log('CompanyService: injected id into payload', name: 'CompanyService');
          }
          final company = Company.fromJson(payload);
          dev.log('getCompanyById parsed company id=${company.id}', name: 'CompanyService');
          return company;
        }

        final company = Company.fromJson(Map<String, dynamic>.from(payload));
        dev.log('getCompanyById parsed company (non-map payload) id=${company.id}', name: 'CompanyService');
        return company;
      }
      dev.log('getCompanyById: company not found (status: ${response.statusCode})', name: 'CompanyService');
      throw Exception('Company not found');
    } catch (e, st) {
      dev.log('getCompanyById failed for id=$id', name: 'CompanyService', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> registerCompany(Company company) async {
    try {
      // Build payload similar to ChildService.registerChild: strip nulls/empties and backend-only fields
      final payload = Map<String, dynamic>.from(company.toJson());
      payload.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));

      // backend rejects certain properties on create
      payload.remove('id');
      payload.remove('createdAt');
      payload.remove('updatedAt');

      // If no address fields were provided, signal backend to inherit address
      final addressKeys = ['address', 'addressNumber', 'addressComplement', 'neighborhood', 'city', 'state', 'zipCode'];
      final hasAddress = addressKeys.any((k) => payload.containsKey(k));
      if (!hasAddress) payload['inheritAddress'] = true;

      dev.log('registerCompany payload: $payload', name: 'CompanyService');

      final response = await dio.post('/companies', data: payload);
      dev.log('registerCompany response status: ${response.statusCode}', name: 'CompanyService');
      dev.log('registerCompany response data: ${response.data}', name: 'CompanyService');

      final ok = response.statusCode == 201 || response.statusCode == 200;
      if (!ok) {
        dev.log('registerCompany returned unexpected status', name: 'CompanyService', error: response);
      }
      return ok;
    } on DioException catch (e) {
      dev.log('CompanyService.registerCompany DioException: ${e.response?.data ?? e.message}', name: 'CompanyService', error: e);
      return false;
    } catch (e, st) {
      dev.log('CompanyService.registerCompany error: $e', name: 'CompanyService', error: e, stackTrace: st);
      return false;
    }
  }

  /// Create company and return created id if available from response.
  Future<String?> createCompanyReturnId(Company company) async {
    try {
      final payload = Map<String, dynamic>.from(company.toJson());
      payload.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));
      payload.remove('id');
      payload.remove('createdAt');
      payload.remove('updatedAt');

      final addressKeys = ['address', 'addressNumber', 'addressComplement', 'neighborhood', 'city', 'state', 'zipCode'];
      final hasAddress = addressKeys.any((k) => payload.containsKey(k));
      if (!hasAddress) payload['inheritAddress'] = true;

      dev.log('createCompany payload: $payload', name: 'CompanyService');

      final response = await dio.post('/companies', data: payload);
      dev.log('createCompany response status: ${response.statusCode}', name: 'CompanyService');
      dev.log('createCompany response data: ${response.data}', name: 'CompanyService');

      if (response.statusCode != 200 && response.statusCode != 201) return null;
      final data = response.data;
      if (data == null) return null;
      if (data is String) return data;
      if (data is Map<String, dynamic>) {
        if (data['id'] != null) return data['id'] as String;
        if (data['data'] is Map && data['data']['id'] != null) return data['data']['id'] as String;
        if (data['company'] is Map && data['company']['id'] != null) return data['company']['id'] as String;
        if (data['result'] is Map && data['result']['id'] != null) return data['result']['id'] as String;
      }
      return null;
    } on DioException catch (e) {
      dev.log('CompanyService.createCompanyReturnId DioException: ${e.response?.data ?? e.message}', name: 'CompanyService', error: e);
      return null;
    } catch (e, st) {
      dev.log('CompanyService.createCompanyReturnId error: $e', name: 'CompanyService', error: e, stackTrace: st);
      return null;
    }
  }

  /// Update company's responsibleId field.
  Future<bool> updateCompanyResponsible(String companyId, String responsibleId) async {
    try {
      if (companyId.isEmpty) return false;
      final payload = {'responsibleId': responsibleId};
      // Use PUT because some backends expect a full replace/update via PUT
      final response = await dio.put('/companies/$companyId', data: payload);
      dev.log('updateCompanyResponsible status: ${response.statusCode}', name: 'CompanyService');
      return response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204;
    } on DioException catch (e) {
      dev.log('CompanyService.updateCompanyResponsible DioException: ${e.response?.data ?? e.message}', name: 'CompanyService', error: e);
      return false;
    } catch (e, st) {
      dev.log('CompanyService.updateCompanyResponsible error: $e', name: 'CompanyService', error: e, stackTrace: st);
      return false;
    }
  }

  /// Delete company by id. Returns true if deleted (200/201/204).
  Future<bool> deleteCompany(String companyId) async {
    try {
      if (companyId.isEmpty) return false;
      final response = await dio.delete('/companies/$companyId');
      dev.log('deleteCompany status: ${response.statusCode}', name: 'CompanyService');
      return response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204;
    } on DioException catch (e) {
      dev.log('CompanyService.deleteCompany DioException: ${e.response?.data ?? e.message}', name: 'CompanyService', error: e);
      return false;
    } catch (e, st) {
      dev.log('CompanyService.deleteCompany error: $e', name: 'CompanyService', error: e, stackTrace: st);
      return false;
    }
  }
}