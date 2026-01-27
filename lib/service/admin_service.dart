import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_space_admin/model/admin.dart';
import 'dart:developer' as dev;
import 'package:kids_space_admin/service/base_service.dart';

class AdminService extends BaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;


  AdminService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Tenta autenticar com Firebase Auth e retorna os dados do colaborador no Firestore
  Future<Admin?> loginAdmin(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = cred.user?.uid;

      if (uid != null) {
        final doc = await _firestore.collection('admins').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final data = Map<String, dynamic>.from(doc.data()!);
          data['id'] = doc.id;
          return Admin.fromJson(data);
        }
      }

      // fallback: try to find by email field
      final query = await _firestore.collection('admins').where('email', isEqualTo: email).limit(1).get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Admin.fromJson(data);
      }
      return null;
    } catch (e) {
      dev.log('AdminService.loginAdmin error: $e');
      return null;
    }
  }

  Future<Admin?> getAdminById(String id) async {
    try {
      final response = await dio.get('/admin/$id');
      if (response.statusCode == 200 && response.data != null) {
        dynamic payload = response.data;
        if (payload is Map<String, dynamic>) {
          if (payload['data'] is Map<String, dynamic>) payload = payload['data'];
          else if (payload['admin'] is Map<String, dynamic>) payload = payload['admin'];
          else if (payload['result'] is Map<String, dynamic>) payload = payload['result'];
        }

        if (payload is Map<String, dynamic>) {
          if (payload['id'] == null || (payload['id'] is String && (payload['id'] as String).isEmpty)) {
            payload['id'] = id;
            dev.log('AdminService: injected id into payload', name: 'AdminService');
          }
          return Admin.fromJson(payload);
        }

        try {
          return Admin.fromJson(Map<String, dynamic>.from(payload));
        } catch (e) {
          dev.log('AdminService.getAdminById parse error: $e');
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      dev.log('AdminService.getAdminById error: $e');
      return null;
    }
  }
}