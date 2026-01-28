import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kids_space_admin/controller/admin_controller.dart';
import 'package:kids_space_admin/model/tile_model.dart';
import 'package:kids_space_admin/utils/tile_helper.dart';
import 'package:kids_space_admin/view/widgets/item_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = GetIt.I<AdminController>();
    final adminName = adminController.loggedAdmin?.name;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar logout'),
                  content: const Text('Deseja realmente sair?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Não')),
                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sim')),
                  ],
                ),
              );
              if (confirm == true) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (adminName != null && adminName.isNotEmpty) ...[
              Text('Bem-vindo, $adminName', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
            ],
            Tile(model: TileModel(
              type: TileType.register_company, 
              icon: Icons.add_business), 
              onTap: () {
                Navigator.of(context).pushNamed(
                  getNavigationRoute(TileType.register_company)
                );
              }),
              const SizedBox(height: 12),
              Tile(model: TileModel(
              type: TileType.manage_company, 
              icon: Icons.manage_accounts), 
              onTap: () {
                Navigator.of(context).pushNamed(
                  getNavigationRoute(TileType.manage_company)
                );
              }),
            const SizedBox(height: 12),
            Tile(model: TileModel(
              type: TileType.companies_summary, 
              icon: Icons.list_alt), 
              onTap: () {
                Navigator.of(context).pushNamed(
                  getNavigationRoute(TileType.companies_summary)
                );
              }),
          ],
        ),
      ),
    );
  }
}
