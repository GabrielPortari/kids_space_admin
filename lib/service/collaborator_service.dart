// Serviço de colaboradores usando Firebase Auth e Firestore
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:kids_space_admin/model/collaborator.dart';
import 'package:kids_space_admin/service/base_service.dart';

class CollaboratorService extends BaseService {

  Future<Collaborator?> getCollaboratorById(String id) async {
    try {
      final response = await dio.get('/collaborator/$id');
      if (response.statusCode == 200 && response.data != null) {
        dynamic payload = response.data;
        if (payload is Map<String, dynamic>) {
          if (payload['data'] is Map<String, dynamic>) payload = payload['data'];
          else if (payload['collaborator'] is Map<String, dynamic>) payload = payload['collaborator'];
          else if (payload['result'] is Map<String, dynamic>) payload = payload['result'];
        }

        if (payload is Map<String, dynamic>) {
          if (payload['id'] == null || (payload['id'] is String && (payload['id'] as String).isEmpty)) {
            payload['id'] = id;
            dev.log('CollaboratorService: injected id into payload', name: 'CollaboratorService');
          }
          return Collaborator.fromJson(payload);
        }

        try {
          return Collaborator.fromJson(Map<String, dynamic>.from(payload));
        } catch (e) {
          dev.log('CollaboratorService.getCollaboratorById parse error: $e');
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      dev.log('CollaboratorService.getCollaboratorById error: $e');
      return null;
    }
  }

  Future<List<Collaborator>> getCollaboratorsByCompanyId(String companyId) async {
    try {
      final response = await dio.get('/collaborator/company/$companyId');
      if (response.statusCode != 200 && response.statusCode != 201) return [];
      final data = response.data;
      List<dynamic> items = [];
      if (data is List) {
        items = data;
      } else if (data is Map<String, dynamic>) {
        if (data['data'] is List) items = data['data'];
        else if (data['collaborators'] is List) items = data['collaborators'];
        else items = [data];
      }

      final List<Collaborator> list = items.map((e) {
        if (e is Collaborator) return e;
        if (e is Map<String, dynamic>) return Collaborator.fromJson(Map<String, dynamic>.from(e));
        try {
          return Collaborator.fromJson(Map<String, dynamic>.from(e));
        } catch (_) {
          return null;
        }
      }).whereType<Collaborator>().toList();
      return list;
    } on DioException catch (e) {
      dev.log('CollaboratorService.getCollaboratorsByCompanyId DioException: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      dev.log('CollaboratorService.getCollaboratorsByCompanyId error: $e');
      return [];
    }
  }

  Future<bool> deleteCollaborator(String id) async {
    try {
      if (id.isEmpty) return false;
      final response = await dio.delete('/collaborator/$id');
      return response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204;
    } on DioException catch (e) {
      dev.log('CollaboratorService.deleteCollaborator DioException: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      dev.log('CollaboratorService.deleteCollaborator error: $e');
      return false;
    }
  }

  Future<bool> updateCollaborator(Collaborator collaborator) async {
    try {
      final id = collaborator.id;
      if (id == null || id.isEmpty) return false;

      final payload = Map<String, dynamic>.from(collaborator.toJson());
      payload.removeWhere((k, v) => v == null);
      payload.remove('id');
      payload.remove('createdAt');
      payload.remove('updatedAt');
      payload.remove('companyId');

      final response = await dio.put('/collaborator/$id', data: payload);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      dev.log('CollaboratorService.updateCollaborator DioException: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      dev.log('CollaboratorService.updateCollaborator error: $e');
      return false;
    }
  }

  Future<bool> createCollaborator(Collaborator collaborator) async {
    try {
      final payload = Map<String, dynamic>.from(collaborator.toJson());
      // remove nulls
      payload.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));
      // backend rejects certain properties on create
      payload.remove('id');
      payload.remove('createdAt');
      payload.remove('updatedAt');
      payload.remove('userType');
      if (!payload.containsKey('companyId')) {
        dev.log('CollaboratorService.createCollaborator: companyId not present in payload', name: 'CollaboratorService');
      }
      dev.log('CollaboratorService.createCollaborator payload: $payload', name: 'CollaboratorService');
      final response = await dio.post('/collaborator', data: payload);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      dev.log('CollaboratorService.createCollaborator DioException: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      dev.log('CollaboratorService.createCollaborator error: $e');
      return false;
    }
  }

  /// Create collaborator and return its created id if available from response.
  Future<String?> createCollaboratorReturnId(Collaborator collaborator) async {
    try {
      final payload = Map<String, dynamic>.from(collaborator.toJson());
      payload.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));
      payload.remove('id');
      payload.remove('createdAt');
      payload.remove('updatedAt');
      
      if (!payload.containsKey('companyId')) {
        dev.log('CollaboratorService.createCollaboratorReturnId: companyId not present in payload', name: 'CollaboratorService');
      }
      dev.log('CollaboratorService.createCollaboratorReturnId payload: $payload', name: 'CollaboratorService');

      final response = await dio.post('/collaborator', data: payload);
      if (response.statusCode != 200 && response.statusCode != 201) return null;
      final data = response.data;
      // try multiple shapes to locate id
      if (data == null) return null;
      if (data is String) return data;
      if (data is Map<String, dynamic>) {
        if (data['id'] != null) return data['id'] as String;
        if (data['data'] is Map && data['data']['id'] != null) return data['data']['id'] as String;
        if (data['collaborator'] is Map && data['collaborator']['id'] != null) return data['collaborator']['id'] as String;
        if (data['result'] is Map && data['result']['id'] != null) return data['result']['id'] as String;
      }
      return null;
    } on DioException catch (e) {
      dev.log('CollaboratorService.createCollaboratorReturnId DioException: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      dev.log('CollaboratorService.createCollaboratorReturnId error: $e');
      return null;
    }
  }
}