import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/admin_controller.dart';
import 'package:kids_space_admin/controller/auth_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = GetIt.I<AuthController>();
  final AdminController _adminController = GetIt.I<AdminController>();

  @override
  void initState() {
    super.initState();
    _startSplashFlow();
  }

  Future<void> _startSplashFlow() async {
    final valid = await _authController.ensureSessionValid();
    if (!valid) {
      try { await _authController.logout(); } catch (_) {}
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (c) => AlertDialog(
          title: Text('Sessão expirada'),
          content: Text('Sua sessão expirou. Por favor, faça login novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    await _checkLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings_outlined, size: 80),
            const SizedBox(height: 24),
            Text(
              'Kids Space Admin',
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLoggedUser() async {
    await _authController.checkLoggedUser();
      // refresh collaborator from API to ensure latest fields (roles/userType, companyId, etc.)
      var loggedAdmin = _adminController.loggedAdmin;
      try {
        if (loggedAdmin != null && loggedAdmin.id != null) {
          final refreshed = await _adminController.getAdminById(loggedAdmin.id!);
          if (refreshed != null) {
            await _adminController.setLoggedAdmin(refreshed);
            loggedAdmin = refreshed;
          }
        }
      } catch (e) {
        // Falha ao atualizar colaborador logado, prosseguir com o que já temos
      }
    if (!mounted) return;
    if (loggedAdmin != null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    Navigator.pushReplacementNamed(context, '/login');
  }
}